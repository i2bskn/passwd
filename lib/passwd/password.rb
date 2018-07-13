class Passwd
  class Password
    extend Forwardable

    attr_reader :passwd, :plain, :salt
    def_delegator :passwd, :config

    def initialize(passed, plain = nil, salt = nil)
      @passwd = passed
      @plain  = plain || random_password
      @salt   = salt || random_salt
    end

    private

      def random_password
        Array.new(config.password_length) { config.letters[rand(config.letters.size)] }
      end

      def random_salt
        Array.new(config.salt_length) { config.letters[rand(config.letters.size)] }
      end
  end
end
