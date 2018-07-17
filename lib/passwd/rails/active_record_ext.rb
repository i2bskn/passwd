module Passwd::Rails
  module ActiveRecordExt
    def with_authenticate(passwd: nil, user_id: :email, salt: :salt, password: :password)
      passwd ||= Passwd.current
      define_instance_auth_with_passwd(passwd, salt, password)
      define_singleton_auth_with_passwd(user_id)
    end

    private

      def define_instance_auth_with_passwd(passwd, salt_col, password_col)
        define_method :authenticate do |plain|
          passwd.hashed_password(plain, send(salt_col)) == send(password_col)
        end
      end

      def define_singleton_auth_with_passwd(user_id_col)
        define_singleton_method :authenticate do |user_id, plain|
          user = find_by(user_id_col => user_id)
          return nil unless user

          user.authenticate(plain) ? user : nil
        end
      end
  end
end
