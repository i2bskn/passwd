# coding: utf-8

module Passwd
  module ActiveRecord
    module ClassMethods
      def define_column(options={})
        idc = options[:id] || :email
        saltc = options[:salt] || :salt
        passwordc = options[:password] || :password

        define_singleton_method :authenticate do |id, pass|
          user = self.where(idc => id).first
          user if user && Passwd.auth(pass, user.send(saltc), user.send(passwordc))
        end

        define_method :authenticate do |pass|
          Passwd.auth(pass, self.send(saltc), self.send(passwordc))
        end

        define_method :set_password do |pass=nil|
          password = pass || Passwd.create
          salt = self.send(saltc) || Passwd.hashing("#{self.send(idc)}#{Time.now.to_s}")
          self.send("#{saltc.to_s}=", salt)
          self.send("#{passwordc.to_s}=", Passwd.hashing("#{salt}#{password}"))
          password
        end

        define_method :update_password do |old, new|
          if Passwd.auth(old, self.send(saltc), self.send(passwordc))
            set_password(new)
          else
            false
          end
        end
      end
    end

    class << self
      def included(klass)
        klass.extend ClassMethods
      end
    end
  end
end