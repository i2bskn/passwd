# coding: utf-8

require "passwd/configuration"

module Passwd
  @config = Configuration.new

  module Base
    def create(options={})
      config = @config.dup
      config.merge options
      Array.new(config.length){config.letters[rand(config.letters.size)]}.join
    end

    def auth(password_text, salt_hash, password_hash)
      enc_pass = Passwd.hashing("#{salt_hash}#{password_text}")
      password_hash == enc_pass
    end

    def hashing(plain)
      Digest::SHA1.hexdigest plain
    end

    def configure(options={}, &block)
      if block_given?
        @config.configure &block
      else
        if options.empty?
          @config
        else
          @config.merge options
        end
      end
    end
    alias :config :configure

    def reset_config
      @config.reset
    end
  end

  extend Base
end
