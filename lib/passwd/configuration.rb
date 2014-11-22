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
      KINDS.detect {|k| self.send(k)} || (raise ConfigError, "letters is empry.")
      LETTERS.zip(KINDS).map {|l, k|
        self.send(l) if self.send(k)
      }.compact.flatten
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
      def self.extended(base)
        base.send(:include, Accessible)
      end

      def configure(options = {}, &block)
        PwConfig.merge!(options) unless options.empty?
        PwConfig.configure(&block) if block_given?
      end

      def policy_configure(&block)
        PwConfig.policy.configure(&block) if block_given?
      end
    end

    module Accessible
      def self.included(base)
        base.const_set(:PwConfig, Configuration.new)
      end
    end
  end
end

