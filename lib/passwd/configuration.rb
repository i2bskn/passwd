module Passwd
  class Configuration
    KINDS = %i(lower upper number).freeze
    LETTERS = KINDS.map {|k| "letters_#{k}".to_sym}.freeze

    VALID_OPTIONS = [
      :algorithm,
      :length,
    ].concat(KINDS).concat(LETTERS).freeze

    attr_accessor *VALID_OPTIONS

    def initialize
      reset
    end

    def configure
      yield self
    end

    KINDS.each do |kind|
      define_method "#{kind}_chars" do
        self.send("letters_#{kind}") || []
      end
    end

    def letters
      KINDS.detect {|k| self.send(k)} || (raise "letters is empty")
      LETTERS.map {|l| self.send(l)}.flatten
    end

    def to_options
      {
        length: self.length,
        letters: self.letters
      }
    end

    def reset
      self.algorithm = :sha512
      self.length = 8
      self.lower = true
      self.upper = true
      self.number = true
      self.letters_lower = ("a".."z").to_a
      self.letters_upper = ("A".."Z").to_a
      self.letters_number = ("0".."9").to_a
    end

    module Accessible
      def self.included(base)
        base.const_set(:Config, Configuration.new)
      end
    end
  end

  include Configuration::Accessible
end

