# coding: utf-8

require "spec_helper"

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

    context "#auth" do
      it "return true with valid password" do
        password = Passwd.create
        salt_hash = Passwd.hashing(Time.now.to_s)
        password_hash = Passwd.hashing("#{salt_hash}#{password}")
        expect(Passwd.auth(password, salt_hash, password_hash)).to eq(true)
      end

      it "return false with invalid password" do
        password = "Secret!!"
        salt_hash = Passwd.hashing(Time.now.to_s)
        password_hash = Passwd.hashing("#{salt_hash}#{password}")
        expect(Passwd.auth("Secret!", salt_hash, password_hash)).to eq(false)
      end
    end

    context "#hashing" do
      it "return string object" do
        expect(Passwd.hashing(Passwd.create).class).to eq(String)
      end

      it "return hashed password" do
        password = Passwd.create
        password_hash = Digest::SHA1.hexdigest(password)
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
end