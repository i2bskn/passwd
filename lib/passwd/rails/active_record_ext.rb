module Passwd::Rails
  module ActiveRecordExt
    def with_authenticate(passwd: nil, user_id: :email, password: :password)
      passwd ||= Passwd.current
      define_singleton_auth_with_passwd(user_id)
      define_instance_auth_with_passwd(passwd, password)
      define_instance_set_password(passwd, password)
    end

    private

      def define_singleton_auth_with_passwd(user_id_col)
        define_singleton_method :authenticate do |user_id, plain|
          user = find_by(user_id_col => user_id)
          return nil unless user

          user.authenticate(plain) ? user : nil
        end
      end

      def define_instance_auth_with_passwd(passwd, password_col)
        define_method :authenticate do |plain|
          BCrypt::Password.new(send(password_col)) == plain
        end
      end

      def define_instance_set_password(passwd, password_col)
        define_method :set_password do |plain = nil|
          plain ||= passwd.random
          send("#{password_col}=", passwd.password_hashing(plain))
          plain
        end
      end
  end
end
