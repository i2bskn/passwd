require "digest/sha1"
require "digest/sha2"

require "passwd/version"
require "passwd/errors"
require "passwd/policy"
require "passwd/configuration"
require "passwd/base"
require "passwd/salt"
require "passwd/password"
require "passwd/rails/railtie"
require "passwd/rails/active_record"

module Passwd
  include Configuration::Accessible
  extend Configuration::Writable
  extend Base

  def self.policy_check(plain)
    Password.from_plain(plain).valid?
  end

  def self.match?(plain, salt_hash, hash)
    Password.from_hash(hash, salt_hash).match?(plain)
  end
end

if defined?(ActiveRecord)
  class ActiveRecord::Base
    def self.with_authenticate(options = {})
      id_name = options.fetch(:id, :email)
      salt_name = options.fetch(:salt, :salt)
      password_name = options.fetch(:password, :password)

      _define_to_password(salt_name, password_name)
      _define_singleton_auth(id_name)
      _define_instance_auth
      _define_set_password(id_name, salt_name, password_name)
      _define_update_password(salt_name, password_name)
    end

    private
      def _define_to_password(salt_name, password_name)
        define_method :to_password do
          _salt_hash = self.send(salt_name)
          _password = self.send(password_name)
          Passwd::Password.from_hash(_password, _salt_hash))
        end
      end

      def _define_singleton_auth(id_name)
        define_singleton_method :authenticate do |_id, _pass|
          user = self.find_by(id_name => _id)
          user if user && user.to_password.match?(_pass)
        end
      end

      def _define_instance_auth
        define_method :authenticate do |_pass|
          self.to_password.match?(_pass)
        end
      end

      def _define_set_password(id_name, salt_name, password_name)
        define_method :set_password do |_pass = nil|
          _password = _pass || Passwd.random
          _salt = self.send(salt_name) || Passwd::Salt.
          _salt ||= Passwd.digest_without_stretching("#{self.send(id_name)}#{Time.now.to_s}")
          self.send("#{salt_name}=", _salt)
          self.send("#{password_name}=", Passwd.digest_without_stretching("#{_salt}#{_password}"))
          _password
        end
      end

      def _define_update_password(salt_name, password_name)
        define_method :update_password do |_old_pass, _new_pass, _policy = false|
          _pass = self.to_password
          if _pass.match?(_old_pass)
            if _policy
              raise unless Passwd.policy_check(_new_pass)
            end

            self.set_password(_new_pass)
          else
            raise
          end
        end
      end
  end
end

