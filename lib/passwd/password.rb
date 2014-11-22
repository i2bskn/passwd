module Passwd
  class Password
    include Base

    attr_reader :plain, :hash, :salt

    def initialize(options = {})
      options = default_options.merge(options)

      if options.has_key?(:hash)
        raise ArgumentError unless options.has_key?(:salt_hash)
        @salt = Salt.from_hash(options[:salt_hash], self)
        @hash = options[:hash]
      else
        @salt =
          case
          when options.has_key?(:salt_hash)
            Salt.from_hash(options[:salt_hash], self)
          when options.has_key?(:salt_plain)
            Salt.from_plain(options[:salt_plain], self)
          else
            Salt.new(password: self)
          end
        self.update_plain(options[:plain])
      end
    end

    def update_plain(value)
      @plain = value
      rehash
    end

    def update_hash(value, salt_hash)
      @plain = nil
      @hash = value
      self.salt.update_hash(salt_hash)
    end

    def rehash
      raise PasswdError unless self.plain
      @hash = digest([self.salt.hash, self.plain].join)
    end

    def match?(value)
      self.hash == digest([self.salt.hash, value].join)
    end

    def ==(other)
      match?(other)
    end

    def to_s
      self.plain.to_s
    end

    def valid?
      raise PasswdError unless self.plain

      return false if PwConfig.policy.min_length > self.plain.size

      Configuration::KINDS.each do |key|
        if PwConfig.policy.send("require_#{key}")
          return false unless include_char?(PwConfig.send("letters_#{key}"))
        end
      end
      true
    end

    def self.from_plain(value, options = {})
      new(options.merge(plain: value))
    end

    def self.from_hash(value, salt_hash)
      new(hash: value, salt_hash: salt_hash)
    end

    private
      def default_options
        {plain: random}
      end

      def include_char?(letters)
        raise PasswdError unless self.plain
        self.plain.chars.uniq.each {|c| return true if letters.include?(c)}
        false
      end
  end
end

