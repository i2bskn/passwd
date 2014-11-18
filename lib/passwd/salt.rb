module Passwd
  class Salt
    include Hashlib

    attr_reader :plain, :hash

    def initialize(options = {})
      options.merge! default_options
      if options.has_key?(:hash)
        self.hash = options[:hash]
      else
        self.plain = options[:plain] || (raise ArgumentError)
      end
    end

    def plain=(value)
      @plain = value
      @hash = digest(value)
    end

    def hash=(value)
      @plain = nil
      @hash = value
    end

    def self.from_plain(value)
      new(plain: value)
    end

    def self.from_hash(value)
      new(hash: value)
    end

    private
      def default_options
        {plain: Time.now.to_s}
      end
  end
end

