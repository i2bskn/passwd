# coding: utf-8

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require "passwd"
require "digest/sha1"

describe Passwd do
  describe "singleton methods" do
    context "#create" do
      it "return string object" do
        expect(Passwd.create.class).to eq(String)
      end

      it "password was created 8 characters" do
        expect(Passwd.create.size).to eq(8)
      end

      it "password was created specified characters" do
        expect(Passwd.create(length: 10).size).to eq(10)
      end

      it "password create without lower case" do
        password = Passwd.create(lower: false)
        expect(("a".."z").to_a.include?(password)).to eq(false)
      end

      it "password create without upper case" do
        password = Passwd.create(upper: false)
        expect(("A".."Z").to_a.include?(password)).to eq(false)
      end

      it "password create without number" do
        password = Passwd.create(number: false)
        expect(("0".."9").to_a.include?(password)).to eq(false)
      end
    end

    context "#policy_check" do
      it "return true with valid password" do
        expect(Passwd.policy_check("09aVCud5")).to eq(true)
      end

      it "return false with less number of characters" do
        expect(Passwd.policy_check("Secret")).to eq(false)
      end

      it "return false with less number of types" do
        expect(Passwd.policy_check("password")).to eq(false)
      end

      it "require lower case if require_lower is true" do
        password = Passwd.create(lower: false)
        expect(
          Passwd.policy_check(password, min_type: 1, specify_type: true, require_lower: true)
        ).to eq(false)
      end

      it "require upper case if require_upper is true" do
        password = Passwd.create(upper: false)
        expect(
          Passwd.policy_check(password, min_type: 1, specify_type: true, require_upper: true)
        ).to eq(false)
      end

      it "require number case if require_number is true" do
        password = Passwd.create(number: false)
        expect(
          Passwd.policy_check(password, min_type: 1, specify_type: true, require_number: true)
        ).to eq(false)
      end
    end

    context "#hashing" do
      it "return string object" do
        expect(Passwd.hashing(Passwd.create).class).to eq(String)
      end

      it "return hashed password" do
        password = Passwd.create
        password_hash = Digest::SHA1.digest(password)
        expect(Passwd.hashing(password)).to eq(password_hash)
      end
    end

    context "#config" do
      before(:all) do
        @default_value = Passwd.config.clone
      end

      after(:all) do
        Passwd.config(@default_value)
      end

      it "return config hash" do
        expect(Passwd.config.class).to eq(Hash)
      end

      it "set config value" do
        old_value = Passwd.config[:length]
        Passwd.config(length: 10)
        expect(Passwd.config[:length]).not_to eq(old_value)
      end
    end

    context "#policy" do
      before(:all) do
        @default_value = Passwd.policy.clone
      end

      after(:all) do
        Passwd.policy(@default_value)
      end

      it "return policy hash" do
        expect(Passwd.policy.class).to eq(Hash)
      end

      it "set config value" do
        old_value = Passwd.policy[:min_length]
        Passwd.policy(min_length: 10)
        expect(Passwd.policy[:min_length]).not_to eq(old_value)
      end
    end
  end

  describe "instance methods" do
    context "#initialize" do
      it "set instance valiables" do
        password = Passwd.new
        expect(password.text.size).to eq(8)
        expect(password.text.class).to eq(String)
        expect(password.hash.class).to eq(String)
      end

      it "@text is specified password" do
        pass_text = Passwd.create
        password = Passwd.new(pass_text)
        expect(password.text).to eq(pass_text)
      end

      it "@hash is hash of specified password" do
        pass_text = Passwd.create
        pass_hash = Digest::SHA1.digest(pass_text)
        password = Passwd.new(pass_text)
        expect(password.hash).to eq(pass_hash)
      end
    end

    context "#text=" do
      before(:each) do
        @password = Passwd.new("Secret!!")
      end

      it "@text is changed" do
        old_password = @password.text
        @password.text = Passwd.create
        expect(@password.text).not_to eq(old_password)
      end

      it "@hash is changed" do
        old_hash = @password.hash
        @password.text = Passwd.create
        expect(@password.hash).not_to eq(old_hash)
      end
    end

    context "#policy_check" do
      it "Passwd.policy_check is called with pass_text" do
        pass_text = Passwd.create
        Passwd.should_receive(:policy_check).with(pass_text)
        password = Passwd.new(pass_text)
        password.policy_check
      end
    end
  end
end