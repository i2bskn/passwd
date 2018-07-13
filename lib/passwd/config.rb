class Passwd
  class Config
    VALID_OPTIONS = [
      :algorithm,
      :stretching,
      :password_length,
      :salt_length,
      :letters,
    ].freeze

    attr_accessor *VALID_OPTIONS

    def initialize(options = {})
      reset
      merge(options)
    end

    def configure
      yield self
    end

    def merge(options)
      options.keys.each { |key| send("#{key}=", options[key]) }
      self
    end

    def reset
      @algorithm       = :sha512
      @stretching      = 100
      @password_length = 10
      @salt_length     = 10
      @letters         = [("a".."z"), ("A".."Z"), ("0".."9")].map(&:to_a).flatten
    end
  end
end
