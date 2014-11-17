require "passwd/configuration/config"
require "passwd/configuration/tmp_config"
require "passwd/configuration/policy"

module Passwd
  @config = Config.instance
  @policy = Policy.instance

  module Base
    def create(options = {})
      config = options.empty? ? @config : TmpConfig.new(@config, options)
      Array.new(config.length){config.letters[rand(config.letters.size)]}.join
    end

    def auth(password_text, salt_hash, password_hash)
      password_hash == hashing("#{salt_hash}#{password_text}")
    end

    def hashing(plain, algorithm = nil)
      algorithm = algorithm ? algorithm.to_s.upcase : @config.algorithm.to_s.upcase
      Digest.const_get(algorithm).hexdigest plain
    end

    def confirm_check(password, confirm, with_policy = false)
      raise PasswordNotMatch, "Password not match" if password != confirm
      return true unless with_policy
      policy_check(password)
    end

    def configure(options = {}, &block)
      if block_given?
        @config.configure &block
      else
        options.empty? ? @config : @config.merge(options)
      end
    end
    alias :config :configure

    def policy_configure(&block)
      block_given? ? @policy.configure(&block) : @policy
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
end

