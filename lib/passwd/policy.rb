module Passwd
  class Policy
    VALID_OPTIONS = [
      :min_length,
      :require_lower,
      :require_upper,
      :require_number
    ].freeze

    attr_accessor *VALID_OPTIONS

    def initialize
      reset
    end

    def configure
      yield self
    end

    def reset
      self.min_length = 8
      self.require_lower = true
      self.require_upper = false
      self.require_number = true
    end
  end
end

