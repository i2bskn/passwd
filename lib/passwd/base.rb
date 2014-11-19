module Passwd
  module Base
    def random(options = {})
      c = Config.merge(options)
      Array.new(c.length){c.letters[rand(c.letters.size)]}.join
    end

    def digest(plain, _algorithm = nil)
      _algorithm ||= Config.algorithm

      if Config.stretching
        _pass = plain
        Config.stretching.times do
          _pass = digest_without_stretching(_pass, _algorithm)
        end
      else
        digest_without_stretching(plain, _algorithm)
      end
    end

    def digest_without_stretching(plain, _algorithm = nil)
      algorithm(_algorithm || Config.algorithm).hexdigest(plain)
    end

    private
      def algorithm(_algorithm)
        Digest.const_get(_algorithm.upcase, false)
      end
  end
end

