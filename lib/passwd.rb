# coding: utf-8

require "passwd/version"
require "digest/sha1"

class Passwd
  attr_reader :text, :hash
  @@config = {
    length: 8,
    lower: true,
    upper: true,
    number: true,
    letters_lower: ('a'..'z').to_a,
    letters_upper: ('A'..'Z').to_a,
    letters_number: ('0'..'9').to_a
  }

  @@policy = {
    min_length: 8,
    min_type: 2,
    specify_type: false,
    require_lower: true,
    require_upper: true,
    require_number: true
  }

  def initialize(password=nil)
    if password.nil?
      # Create letters
      letters = Array.new
      letters += @@config[:letters_lower] if @@config[:lower]
      letters += @@config[:letters_upper] if @@config[:upper]
      letters += @@config[:letters_number] if @@config[:number]

      # Create random password
      @text = Array.new(@@config[:length]){letters[rand(letters.size)]}.join
    else
      @text = password
    end
    # @text = password.nil? ? self.class.create : password
    @hash = Passwd.hashing(@text)
  end

  def text=(password)
    @text = password
    @hash = Passwd.hashing(@text)
    @text
  end

  def policy_check
    Passwd.policy_check @text
  end

  class << self
    def create(options={})
      config = @@config.merge(options)

      # Create letters
      letters = Array.new
      letters += config[:letters_lower] if config[:lower]
      letters += config[:letters_upper] if config[:upper]
      letters += config[:letters_number] if config[:number]

      # Create random password
      Array.new(config[:length]){letters[rand(letters.size)]}.join
    end

    def policy_check(passwd, options={})
      policy = @@policy.merge(options)

      # Check number of characters
      return false if passwd.size < policy[:min_length]

      # Check number of types of characters
      ctype = Array.new
      passwd.each_char.with_index do |char, i|
        case
        when @@config[:letters_lower].include?(char) then ctype << 0
        when @@config[:letters_upper].include?(char) then ctype << 1
        when @@config[:letters_number].include?(char) then ctype << 2
        end
      end
      ctype.uniq!
      return false if ctype.size < policy[:min_type]

      # Check of each character type
      if policy[:specify_type]
        return false if policy[:require_lower] && !ctype.include?(0)
        return false if policy[:require_upper] && !ctype.include?(1)
        return false if policy[:require_number] && !ctype.include?(2)
      end

      true
    end

    def hashing(passwd)
      Digest::SHA1.hexdigest passwd
    end

    def config(options={})
      @@config.merge!(options)
    end

    def policy(options={})
      @@policy.merge!(options)
    end
  end
end
