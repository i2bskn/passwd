# coding: utf-8

module Passwd
  module ActiveRecord
    module ClassMethods
      def define_column(options={})
        id_name = options.fetch(:id, :email)
        salt_name = options.fetch(:salt, :salt)
        password_name = options.fetch(:password, :password)

        define_singleton_auth(id_name, salt_name, password_name)
        define_instance_auth(id_name, salt_name, password_name)
        define_set_password(id_name, salt_name, password_name)
        define_update_password(salt_name, password_name)
      end

      private
      def define_singleton_auth(id_name, salt_name, password_name)
        define_singleton_method :authenticate do |id, pass|
          user = self.where(id_name => id).first
          user if user && Passwd.auth(pass, user.send(salt_name), user.send(password_name))
        end
      end

      def define_instance_auth(id_name, salt_name, password_name)
        define_method :authenticate do |pass|
          Passwd.auth(pass, self.send(salt_name), self.send(password_name))
        end
      end

      def define_set_password(id_name, salt_name, password_name)
        define_method :set_password do |pass=nil|
          password = pass || Passwd.create
          salt = self.send(salt_name) || Passwd.hashing("#{self.send(id_name)}#{Time.now.to_s}")
          self.send("#{salt_name.to_s}=", salt)
          self.send("#{password_name.to_s}=", Passwd.hashing("#{salt}#{password}"))
          password
        end
      end

      def define_update_password(salt_name, password_name)
        define_method :update_password do |old_pass, new_pass|
          if Passwd.auth(old_pass, self.send(salt_name), self.send(password_name))
            set_password(new_pass)
          else
            false
          end
        end
      end
    end

    class << self
      def included(base)
        base.extend ClassMethods
      end
    end
  end
end