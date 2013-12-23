# coding: utf-8

module Passwd
  class AbstractConfig
    VALID_OPTIONS_KEYS = [
      :algorithm,
      :length,
      :lower,
      :upper,
      :number,
      :letters_lower,
      :letters_upper,
      :letters_number
    ].freeze

    attr_accessor *VALID_OPTIONS_KEYS

    def configure
      yield self
    end

    def merge(configs)
      configs.keys.each do |k|
        send("#{k}=", configs[k])
      end
    end

    def letters
      chars = []
      chars.concat(self.letters_lower) if self.lower
      chars.concat(self.letters_upper) if self.upper
      chars.concat(self.letters_number) if self.number
      raise "letters is empty" if chars.empty?
      chars
    end
  end
end
