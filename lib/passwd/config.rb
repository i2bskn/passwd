class Passwd
  class Config
    VALID_OPTIONS = [
      :stretching,
      :length,
      :characters,
    ].freeze

    attr_accessor(*VALID_OPTIONS)

    def initialize(options = {})
      reset
      merge(options)
    end

    def merge(options)
      options.each_key {|key| send("#{key}=", options[key]) }
      self
    end

    def reset
      @stretching = 12
      @length     = 10
      @characters = [("a".."z"), ("A".."Z"), ("0".."9")].map(&:to_a).flatten
    end
  end
end
