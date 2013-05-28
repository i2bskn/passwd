# coding: utf-8

require "digest/sha1"

require "passwd/version"
require "passwd/password"
require "passwd/active_record"

module Passwd
  @@config = {
    length: 8,
    lower: true,
    upper: true,
    number: true,
    letters_lower: ('a'..'z').to_a,
    letters_upper: ('A'..'Z').to_a,
    letters_number: ('0'..'9').to_a
  }

  class << self
    def create(options={})
      config = @@config.merge(options)
      letters = get_retters(config)

      # Create random password
      Array.new(config[:length]){letters[rand(letters.size)]}.join
    end

    def get_retters(config)
      # Create letters
      letters = Array.new
      letters += config[:letters_lower] if config[:lower]
      letters += config[:letters_upper] if config[:upper]
      letters += config[:letters_number] if config[:number]
      letters
    end

    def auth(password_text, salt_hash, password_hash)
      enc_pass = Passwd.hashing("#{salt_hash}#{password_text}")
      password_hash == enc_pass
    end

    def hashing(passwd)
      Digest::SHA1.hexdigest passwd
    end

    def config(options={})
      @@config.merge!(options)
    end
  end
end
