module Passwd
  class Configuration
    KINDS = %i(lower upper number).freeze
    LETTERS = KINDS.map {|k| "letters_#{k}".to_sym}.freeze

    VALID_OPTIONS = [
      :algorithm,
      :length,
      :policy,
      :stretching,
    ].concat(KINDS).concat(LETTERS).freeze

    attr_accessor *VALID_OPTIONS

    def initialize
      reset
    end

    def configure
      yield self
    end

    def merge(params)
      self.dup.merge!(params)
    end

    def merge!(params)
      params.keys.each do |key|
        self.send("#{key}=", params[key])
      end
      self
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

    def reset
      self.algorithm = :sha512
      self.length = 8
      self.policy = Policy.new
      self.stretching = nil
      self.lower = true
      self.upper = true
      self.number = true
      self.letters_lower = ("a".."z").to_a
      self.letters_upper = ("A".."Z").to_a
      self.letters_number = ("0".."9").to_a
    end

    module Writable
      def configure(options = {}, &block)
        Config.merge!(options) unless options.empty?
        Config.configure(&block) if block_given?
      end

      def policy_configure(&block)
        Config.policy.configure(&block) if block_given?
      end
    end

    module Accessible
      def self.included(base)
        base.const_set(:Config, Configuration.new)
      end
    end
  end
end
