# coding: utf-8

require "passwd/configuration/abstract_config"

module Passwd
  class Config < AbstractConfig
    include Singleton

    def initialize
      reset
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
  end
end
