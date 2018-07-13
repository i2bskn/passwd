module Passwd
  class Config
    VALID_OPTIONS = [
      :algorithm,
      :stretching,
      :letters,
    ].freeze

    attr_accessor *VALID_OPTIONS

    def initialize
      reset
    end

    def configure
      yield self
    end

    def merge(params)
      params.keys.each do |key|
        self.send("#{key}=", params[key])
      end
      self
    end

    def reset
      @algorithm  = :sha512
      @stretching = 10
      @letters    = default_letters
    end

    private

      def default_letters
        [("a".."z"), ("A".."Z"), ("0".."9")].map(&:to_a).flatten
      end
  end
end
