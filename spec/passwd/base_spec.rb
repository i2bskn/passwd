# coding: utf-8

require "spec_helper"

describe Passwd do
  describe "extended Base" do
    describe "#create" do
      context "without arguments" do
        let(:password) {Passwd.create}

        it "TmpConfig should not be generated" do
          Passwd::TmpConfig.should_not_receive(:new)
          expect{password}.not_to raise_error
        end

        it "created password should be String object" do
          expect(password.is_a? String).to be_true
        end

        it "created password length should be default length" do
          expect(password.size).to eq(8)
        end
      end

      context "with arguments" do
        it "TmpConfig should be generated" do
          tmp_config = double("tmp_config mock", length: 8, letters: ["a", "b"])
          Passwd::TmpConfig.should_receive(:new).and_return(tmp_config)
          expect{Passwd.create(length: 10)}.not_to raise_error
        end

        it "password was created specified characters" do
          expect(Passwd.create(length: 10).size).to eq(10)
        end

        it "password create without lower case" do
          expect(("a".."z").to_a.include? Passwd.create(lower: false)).to be_false
        end

        it "password create without upper case" do
          expect(("A".."Z").to_a.include? Passwd.create(upper: false)).to be_false
        end

        it "password create without number" do
          expect(("0".."9").to_a.include? Passwd.create(number: false)).to be_false
        end
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

    describe "#confirm_check" do
      context "with out policy check" do
        it "return false if password don't match" do
          expect(Passwd.confirm_check("secret", "invalid")).to be_false
        end

        it "return true if password matches" do
          expect(Passwd.confirm_check("secret", "secret")).to be_true
        end
      end

      context "with policy check" do
        it "return false if invalid password by policy" do
          expect(Passwd.confirm_check("secret", "secret", true)).to be_false
        end

        it "return true if valid password by policy" do
          expect(Passwd.confirm_check("secretpass", "secretpass", true)).to be_false
        end
      end
    end

    describe "#configure" do
      it "return configuration object" do
        expect(Passwd.configure.is_a? Passwd::Config).to be_true
      end

      it "set config value from block" do
        Passwd.configure do |c|
          c.length = 10
        end
        expect(Passwd.configure.length).not_to eq(8)
        expect(Passwd.configure.length).to eq(10)
      end

      it "set config value from hash" do
        Passwd.configure length: 20
        expect(Passwd.config.length).not_to eq(8)
        expect(Passwd.config.length).to eq(20)
      end

      it "alias of configure as config" do
        expect(Passwd.configure.object_id).to eq(Passwd.config.object_id)
      end
    end

    describe "#policy_configure" do
      it "return policy object" do
        expect(Passwd.policy_configure.is_a? Passwd::Policy).to be_true
      end

      it "set policy value from block" do
        Passwd.policy_configure do |c|
          c.min_length = 10
        end
        expect(Passwd.policy_configure.min_length).not_to eq(8)
        expect(Passwd.policy_configure.min_length).to eq(10)
      end
    end

    describe "#policy_check" do
      it "Policy#valid? should be called" do
        Passwd::Policy.instance.should_receive(:valid?).with("secret1234" ,Passwd::Config.instance)
        expect(Passwd.policy_check("secret1234")).not_to raise_error
      end
    end

    describe "#reset_policy" do
      let(:policy) {Passwd::Policy.instance}
      
      before {
        policy.configure do |c|
          c.min_length = 20
          c.require_lower = false
          c.require_upper = true
          c.require_number = false
        end
        Passwd.reset_policy
      }

      it "min_length should be a default" do
        expect(policy.min_length).to eq(8)
      end

      it "require_lower should be a default" do
        expect(policy.require_lower).to be_true
      end

      it "upper should be a default" do
        expect(policy.require_upper).to be_false
      end

      it "number should be a default" do
        expect(policy.require_number).to be_true
      end
    end

    describe "#reset_config" do
      let(:config) {Passwd::Config.instance}
      
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
        Passwd.reset_config
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