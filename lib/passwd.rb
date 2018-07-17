require "digest"
require "forwardable"
require "securerandom"

require "passwd/version"
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
    config.stretching.times.with_object([digest_class.hexdigest([plain, salt].join)]) { |_, pass|
      pass[0] = digest_class.hexdigest(pass[0])
    }.first
  end

  def config
    @config ||= Config.new
  end

  private

    def digest_class
      Digest.const_get(config.algorithm.upcase)
    end
end
