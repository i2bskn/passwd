module Passwd::Rails
  module ActiveRecordExt
    def with_authenticate(passwd: nil, user_id: :email, salt: :salt, password: :password)
      passwd ||= Passwd.current
      define_singleton_auth_with_passwd(user_id)
      define_instance_auth_with_passwd(passwd, salt, password)
      define_instance_set_password(passwd, salt, password)
    end

    private

      def define_singleton_auth_with_passwd(user_id_col)
        define_singleton_method :authenticate do |user_id, plain|
          user = find_by(user_id_col => user_id)
          return nil unless user

          user.authenticate(plain) ? user : nil
        end
      end

      def define_instance_auth_with_passwd(passwd, salt_col, password_col)
        define_method :authenticate do |plain|
          passwd.hashed_password(plain, send(salt_col)) == send(password_col)
        end
      end

      def define_instance_set_password(passwd, salt_col, password_col)
        define_method :set_password do |plain = nil|
          plain ||= passwd.random
          random_salt = Rails.application.config.passwd.random_salt || proc { SecureRandom.uuid }
          send("#{salt_col}=", random_salt.call(self)) unless send(salt_col)
          send("#{password_col}=", passwd.hashed_password(plain, send(salt_col)))
          plain
        end
      end
  end
end
