module Passwd
  module Hashlib
    def digest(plain, _algorithm = nil)
      algorithm(_algorithm || Config.algorithm).hexdigest(plain)
    end

    private
      def algorithm(_algorithm)
        Digest.const_get(_algorithm.upcase, false)
      end
  end
end

