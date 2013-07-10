# coding: utf-8

require "passwd/configuration/config"
require "passwd/configuration/tmp_config"

module Passwd
  @config = Config.instance

  module Base
    def create(options={})
      if options.empty?
        config = @config
      else
        config = TmpConfig.new(@config, options)
      end
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
