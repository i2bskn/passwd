require "bcrypt"
require "passwd/version"
require "passwd/errors"
require "passwd/config"
require "passwd/railtie" if defined?(Rails)

class Passwd
  class << self
    def current
      @current ||= new
    end

    attr_writer :current
  end

  def initialize(conf = nil)
    @config = conf
  end

  def password_hashing(plain)
    BCrypt::Password.create(plain, cost: config.stretching.clamp(BCrypt::Engine::MIN_COST, BCrypt::Engine::MAX_COST))
  end

  def load_password(hashed_password)
    BCrypt::Password.new(hashed_password)
  end

  def random(long = nil)
    Array.new(long || config.length) { config.characters[rand(config.characters.size)] }.join
  end

  def config
    @config ||= Config.new
  end
end
