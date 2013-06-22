# coding: utf-8

require "digest/sha1"

require "passwd/version"
require "passwd/password"
require "passwd/active_record"

module Passwd
  @config = {
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
      config = Passwd.config.merge(config_validator(options))
      letters = get_retters(config)
      Array.new(config[:length]){letters[rand(letters.size)]}.join
    end

    def auth(password_text, salt_hash, password_hash)
      enc_pass = Passwd.hashing("#{salt_hash}#{password_text}")
      password_hash == enc_pass
    end

    def hashing(password)
      Digest::SHA1.hexdigest password
    end

    def config(options={})
      @config.merge!(config_validator(options))
    end

    private
    def get_retters(config)
      ["lower", "upper", "number"].inject([]) do |letters, type|
        letters.concat(config["letters_#{type}".to_sym]) if config[type.to_sym]
        letters
      end
    end

    def config_validator(config_hash)
      parameters = [:length, :lower, :upper, :number, :letters_lower, :letters_upper, :letters_number]
      config = config_hash.inject({}){|r, (k, v)| r.store(k.to_sym, v); r}
      config.select{|k, v| parameters.include? k}
    end
  end
end
