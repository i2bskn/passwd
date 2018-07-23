require "digest"
require "securerandom"

require "passwd/version"
require "passwd/errors"
require "passwd/config"
require "passwd/railtie" if defined?(Rails)

class Passwd
  class << self
    def current
      @current ||= new
    end

    def current=(passwd)
      @current = passwd
    end
  end

  def initialize(conf = nil)
    @config = conf
  end

  def hashed_password(plain, salt)
    config.stretching.to_i.times.with_object([digest_class.hexdigest([plain, salt].join)]) { |_, pass|
      pass[0] = digest_class.hexdigest(pass[0])
    }.first
  end

  def random(n = nil)
    Array.new(n || config.length) { config.letters[rand(config.letters.size)] }.join
  end

  def config
    @config ||= Config.new
  end

  private

    def digest_class
      Digest.const_get(config.algorithm.upcase)
    end
end
