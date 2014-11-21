module Passwd
  module ActiveRecordExt
    def with_authenticate(options = {})
      _id_key = options.fetch(:id, :email)
      _salt_key = options.fetch(:salt, :salt)
      _pass_key = options.fetch(:password, :password)

      _define_passwd(_salt_key, _pass_key)
      _define_singleton_auth(_id_key)
      _define_instance_auth
      _define_set_password(_salt_key, _pass_key)
      _define_update_password(_salt_key, _pass_key)
    end

    private
      def _define_passwd(_salt_key, _pass_key)
        define_method :passwd do |cache = true|
          return @_passwd if cache && @_passwd
          self.reload
          _salt, _pass = self.send(_salt_key), self.send(_pass_key)
          if _salt.present? && _pass.present?
            @_passwd = Passwd::Password.from_hash(_pass, _salt)
          else
            self.set_password
          end
        end
      end

      def _define_singleton_auth(_id_key)
        define_singleton_method :authenticate do |_id, _pass|
          _condition = Array(_id_key).map {|k| "#{k} = :id"}.join(" OR ")
          _user = self.find_by(_condition, id: _id)
          _user if _user && _user.passwd.match?(_pass)
        end
      end

      def _define_instance_auth
        define_method :authenticate do |_pass|
          self.passwd.match?(_pass)
        end
      end

      def _define_set_password(_salt_key, _pass_key)
        define_method :set_password do |_pass = nil|
          _options = _pass ? {plain: _pass} : {}
          _passwd = Passwd::Password.new(_options)
          self.send("#{_salt_key}=", _passwd.salt.hash)
          self.send("#{_pass_key}=", _passwd.hash)
          self.instance_variable_set(:@_passwd, _passwd)
        end
      end

      def _define_update_password(_salt_key, _pass_key)
        define_method :update_password do |_old, _new, _policy = false|
          raise PolicyNotMatch if _policy && !Passwd.policy_check(_new)
          if self.passwd.match?(_old)
            self.set_password(_new)
          else
            raise AuthenticationFails
          end
        end
      end
  end
end

