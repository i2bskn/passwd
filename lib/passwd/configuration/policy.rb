# coding: utf-8

module Passwd
  class Policy
    include Singleton

    VALID_OPTIONS_KEYS = [
      :min_length,
      :require_lower,
      :require_upper,
      :require_number
    ].freeze

    attr_accessor *VALID_OPTIONS_KEYS

    def initialize
      reset
    end

    def configure
      yield self
    end

    def valid?(password, config)
      return false if self.min_length > password.size
      return false if self.require_lower && !include_char?(config.letters_lower, password)
      return false if self.require_upper && !include_char?(config.letters_upper, password)
      return false if self.require_number && !include_char?(config.letters_number, password)
      true
    end

    def include_char?(letters, strings)
      strings.each_char do |c|
        return true if letters.include? c
      end
      false
    end

    def reset
      self.min_length = 8
      self.require_lower = true
      self.require_upper = false
      self.require_number = true
    end
  end
end