require "digest/sha1"
require "digest/sha2"

require "passwd/version"
require "passwd/errors"
require "passwd/policy"
require "passwd/configuration"
require "passwd/base"
require "passwd/salt"
require "passwd/password"
require "passwd/railtie" if defined?(Rails)

module Passwd
  extend Base
  extend Configuration::Writable

  def self.policy_check(plain)
    Password.from_plain(plain).valid?
  end

  def self.match?(plain, salt_hash, hash)
    Password.from_hash(hash, salt_hash).match?(plain)
  end
end

