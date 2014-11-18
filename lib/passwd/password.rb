module Passwd
  class Password
    include Base
    include Hashlib

    attr_accessor :salt
    attr_reader :plain, :hash

    def initialize(options = {})
    end

    private
      def default_options
        {}
      end
  end
end

