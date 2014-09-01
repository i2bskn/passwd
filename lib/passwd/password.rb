module Passwd
  class Password
    attr_reader :text, :hash, :salt_text, :salt_hash

    def initialize(options={})
      @text = options.fetch(:password, Passwd.create)
      @salt_text = options.fetch(:salt_text, Time.now.to_s)
      @salt_hash = Passwd.hashing(@salt_text)
      @hash = Passwd.hashing("#{@salt_hash}#{@text}")
    end

    def text=(password)
      @hash = Passwd.hashing("#{@salt_hash}#{password}")
      @text = password
    end

    def hash=(password_hash)
      @text = nil
      @hash = password_hash
    end

    def salt_text=(salt_text)
      @salt_hash = Passwd.hashing(salt_text)
      @hash = Passwd.hashing("#{@salt_hash}#{@text}")
      @salt_text = salt_text
    end

    def salt_hash=(salt_hash)
      @salt_text = nil
      @hash = Passwd.hashing("#{salt_hash}#{@text}")
      @salt_hash = salt_hash
    end

    def ==(password)
      enc_pass = Passwd.hashing("#{@salt_hash}#{password}")
      @hash == enc_pass
    end
  end
end

