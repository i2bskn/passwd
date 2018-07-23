class Passwd
  class Config
    VALID_OPTIONS = [
      :algorithm,
      :stretching,
      :length,
      :characters,
    ].freeze

    attr_accessor *VALID_OPTIONS

    def initialize(options = {})
      reset
      merge(options)
    end

    def merge(options)
      options.keys.each { |key| send("#{key}=", options[key]) }
      self
    end

    def reset
      @algorithm  = :sha512
      @stretching = 100
      @length     = 10
      @characters = [("a".."z"), ("A".."Z"), ("0".."9")].map(&:to_a).flatten
    end
  end
end
