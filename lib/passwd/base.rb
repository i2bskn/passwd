# coding: utf-8

require "singleton"
require "passwd/configuration/config"
require "passwd/configuration/tmp_config"
require "passwd/configuration/policy"

module Passwd
  @config = Config.instance
  @policy = Policy.instance

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

    def hashing(plain, algorithm=nil)
      if algorithm.nil?
        eval "Digest::#{@config.algorithm.to_s.upcase}.hexdigest \"#{plain}\""
      else
        eval "Digest::#{algorithm.to_s.upcase}.hexdigest \"#{plain}\""
      end
    end

    def confirm_check(password, confirm, with_policy=false)
      raise PasswordNotMatch, "Password not match" if password != confirm
      return true unless with_policy
      Passwd.policy_check(password)
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

    def policy_configure(&block)
      if block_given?
        @policy.configure &block
      else
        @policy
      end
    end

    def policy_check(password)
      @policy.valid?(password, @config)
    end

    def reset_config
      @config.reset
    end

    def reset_policy
      @policy.reset
    end
  end

  extend Base
end
