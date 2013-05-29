# coding: utf-8

require "spec_helper"

describe Passwd do
  let(:default) {@default}

  describe "default settings" do
    let(:config) {Passwd.config}

    it "length should be a default" do
      expect(config[:length]).to eq(default[:length])
    end

    it "lower should be a default" do
      expect(config[:lower]).to eq(default[:lower])
    end

    it "upper should be a default" do
      expect(config[:upper]).to eq(default[:upper])
    end

    it "number should be a default" do
      expect(config[:number]).to eq(default[:number])
    end

    it "letters_lower should be a default" do
      expect(config[:letters_lower]).to eq(default[:letters_lower])
    end

    it "letters_upper should be a default" do
      expect(config[:letters_upper]).to eq(default[:letters_upper])
    end

    it "letters_number should be a default" do
      expect(config[:letters_number]).to eq(default[:letters_number])
    end
  end

  describe ".create" do
    it "create random password" do
      password = Passwd.create
      expect(password.is_a? String).to be_true
      expect(password.size).to eq(default[:length])
    end

    it "password was created specified characters" do
      expect(Passwd.create(length: 10).size).to eq(10)
    end

    it "password create without lower case" do
      password = Passwd.create lower: false
      expect(default[:letters_lower].include? password).to be_false
    end

    it "password create without upper case" do
      password = Passwd.create upper: false
      expect(default[:letters_upper].include? password).to be_false
    end

    it "password create without number" do
      password = Passwd.create(number: false)
      expect(default[:letters_number].include? password).to be_false
    end
  end

  describe ".auth" do
    let!(:password) do
      password = Passwd.create
      salt_hash = Passwd.hashing(Time.now.to_s)
      password_hash = Passwd.hashing("#{salt_hash}#{password}")
      {text: password, salt: salt_hash, hash: password_hash}
    end

    it "return true with valid password" do
      expect(Passwd.auth(password[:text], password[:salt], password[:hash])).to be_true
    end

    it "return false with invalid password" do
      expect(Passwd.auth("invalid", password[:salt], password[:hash])).to be_false
    end

    it "should create exception if not specified arguments" do
      expect(proc{Passwd.auth}).to raise_error
    end
  end

  describe ".hashing" do
    it "return hashed password" do
      Digest::SHA1.should_receive(:hexdigest).with("secret").and_return("hash")
      expect(Passwd.hashing("secret")).to eq("hash")
    end

    it "should create exception if not specified argument" do
      expect(proc{Passwd.hashing}).to raise_error
    end
  end

  describe ".config" do
    after {Passwd.config(default)}

    it "return config hash" do
      expect(Passwd.config.is_a? Hash).to be_true
    end

    it "set config value" do
      Passwd.config(length: 10)
      expect(Passwd.config[:length]).not_to eq(default[:length])
      expect(Passwd.config[:lower]).to eq(default[:lower])
    end
  end

  describe ".get_retters" do
    it "return letters" do
      letters = Passwd.send(:get_retters, default)
      expect(letters.is_a? Array).to be_true
      expect(letters.select{|s| s.is_a? String}).to eq(letters)
      expect(letters).to eq(default[:letters_lower] + default[:letters_upper] + default[:letters_number])
    end

    it "should create exception if not specified argument" do
      expect(proc{Passwd.send(:get_retters)}).to raise_error
    end
  end

  describe ".config_validator" do
    it "convert to symbol the key" do
      config = default.inject({}){|r, (k, v)| r.store(k.to_s, v); r}
      expect(Passwd.send(:config_validator, config)).to eq(default)
    end

    it "delete not defined parameters" do
      config = default.merge(invalid_parameter: true)
      expect(Passwd.send(:config_validator, config)).to eq(default)
    end
  end
end