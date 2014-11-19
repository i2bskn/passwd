module Passwd
  class Salt
    include Base

    attr_reader :plain, :hash

    def initialize(options = {})
      options = default_options.merge(options)

      @password = options[:password]
      if options.has_key?(:hash)
        @plain = nil
        @hash = options[:hash]
      else
        @plain = options[:plain] || (raise ArgumentError)
        @hash = digest_without_stretching(@plain)
      end
    end

    def plain=(value)
      @plain = value
      @hash = digest_without_stretching(@plain)
      update_password!
    end

    def hash=(value)
      @plain = nil
      @hash = value
      update_password!
    end

    def self.from_plain(value, password = nil)
      new(plain: value, password: password)
    end

    def self.from_hash(value, password = nil)
      new(hash: value, password: password)
    end

    private
      def default_options
        {plain: Time.now.to_s}
      end

      def update_password!
        @password.rehash if @password
      end
  end
end

