# coding: utf-8

module Passwd
  class Configuration
    VALID_OPTIONS_KEYS = [
      :length,
      :lower,
      :upper,
      :number,
      :letters_lower,
      :letters_upper,
      :letters_number
    ].freeze

    attr_accessor *VALID_OPTIONS_KEYS

    def initialize
      reset
    end

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

    def reset
      self.length = 8
      self.lower = true
      self.upper = true
      self.number = true
      self.letters_lower = ("a".."z").to_a
      self.letters_upper = ("A".."Z").to_a
      self.letters_number = ("0".."9").to_a
    end
  end
end
