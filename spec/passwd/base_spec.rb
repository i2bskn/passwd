# coding: utf-8

require "spec_helper"

describe Passwd do
  describe "extended Base" do
    let(:default) {Passwd::Configuration.new}

    describe "#create" do
      it "create random password" do
        password = Passwd.create
        expect(password.is_a? String).to be_true
        expect(password.size).to eq(default.length)
      end

      it "password was created specified characters" do
        expect(Passwd.create(length: 10).size).to eq(10)
      end

      it "password create without lower case" do
        password = Passwd.create lower: false
        expect(default.letters_lower.include? password).to be_false
      end

      it "password create without upper case" do
        password = Passwd.create upper: false
        expect(default.letters_upper.include? password).to be_false
      end

      it "password create without number" do
        password = Passwd.create(number: false)
        expect(default.letters_number.include? password).to be_false
      end
    end

    describe "#auth" do
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

    describe "#hashing" do
      it "return hashed password" do
        Digest::SHA1.should_receive(:hexdigest).with("secret").and_return("hash")
        expect(Passwd.hashing("secret")).to eq("hash")
      end

      it "should create exception if not specified argument" do
        expect(proc{Passwd.hashing}).to raise_error
      end
    end

    describe "#configure" do
      after {Passwd.reset_config}

      it "return configuration object" do
        expect(Passwd.configure.is_a? Passwd::Configuration).to be_true
      end

      it "set config value from block" do
        Passwd.configure do |c|
          c.length = 10
        end
        expect(Passwd.configure.length).not_to eq(default.length)
        expect(Passwd.configure.length).to eq(10)
      end

      it "set config value from hash" do
        Passwd.configure length: 20
        expect(Passwd.config.length).not_to eq(default.length)
        expect(Passwd.config.length).to eq(20)
      end

      it "alias of configure as config" do
        expect(Passwd.configure.object_id).to eq(Passwd.config.object_id)
      end
    end

    describe "#reset_config" do
      let(:config) {Passwd.config}
      
      before {
        config.configure do |c|
          c.length = 20
          c.lower = false
          c.upper = false
          c.number = false
          c.letters_lower = ["a"]
          c.letters_upper = ["A"]
          c.letters_number = ["0"]
        end
        config.reset
      }

      it "length should be a default" do
        expect(config.length).to eq(8)
      end

      it "lower should be a default" do
        expect(config.lower).to be_true
      end

      it "upper should be a default" do
        expect(config.upper).to be_true
      end

      it "number should be a default" do
        expect(config.number).to be_true
      end

      it "letters_lower should be a default" do
        expect(config.letters_lower).to eq(("a".."z").to_a)
      end

      it "letters_upper should be a default" do
        expect(config.letters_upper).to eq(("A".."Z").to_a)
      end

      it "letters_number should be a default" do
        expect(config.letters_number).to eq(("0".."9").to_a)
      end
    end
  end
end