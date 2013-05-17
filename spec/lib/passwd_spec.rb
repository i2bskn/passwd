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

  describe 'Password' do
    context "#initialize" do
      it "set instance valiables" do
        password = Passwd::Password.new
        expect(password.text.size).to eq(8)
        expect(password.text.class).to eq(String)
        expect(password.hash.class).to eq(String)
        expect(password.salt_text.class).to eq(String)
        expect(password.salt_hash.class).to eq(String)
      end

      it "@text is specified password" do
        pass_text = Passwd.create
        password = Passwd::Password.new(password: pass_text)
        expect(password.text).to eq(pass_text)
      end

      it "@hash is hash of specified password" do
        pass_text = Passwd.create
        password = Passwd::Password.new(password: pass_text)
        pass_hash = Passwd.hashing("#{password.salt_hash}#{pass_text}")
        expect(password.hash).to eq(pass_hash)
      end

      it "@salt_text is specified salt" do
        salt_text = "salt"
        password = Passwd::Password.new(salt_text: salt_text)
        expect(password.salt_text).to eq(salt_text)
      end

      it "@salt_hash is hash of specified salt" do
        salt_text = "salt"
        salt_hash = Passwd.hashing(salt_text)
        password = Passwd::Password.new(salt_text: salt_text)
        expect(password.salt_hash).to eq(salt_hash)
      end
    end

    context "#text=" do
      before(:each) do
        @password = Passwd::Password.new(password: "Secret!!")
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

    context "#hash=" do
      before(:each) do
        @password = Passwd::Password.new
      end

      it "@text is nil" do
        @password.hash = Passwd.hashing("Secret!!")
        expect(@password.text).to eq(nil)
      end

      it "@hash is changed" do
        old_hash = @password.hash
        @password.hash = Passwd.hashing("Secret!!")
        expect(@password.hash).not_to eq(old_hash)
      end
    end

    context "#salt_text=" do
      before(:each) do
        @password = Passwd::Password.new
      end

      it "@salt_text is changed" do
        old_salt_text = @password.salt_text
        @password.salt_text = "salt"
        expect(@password.salt_text).not_to eq(old_salt_text)
      end

      it "@salt_hash is changed" do
        old_salt_hash = @password.salt_hash
        @password.salt_text = "salt"
        expect(@password.salt_hash).not_to eq(old_salt_hash)
      end

      it "@hash is changed" do
        old_hash = @password.hash
        @password.salt_text = "salt"
        expect(@password.hash).not_to eq(old_hash)
      end
    end

    context "#salt_hash=" do
      before(:each) do
        @password = Passwd::Password.new
      end

      it "@salt_text is nil" do
        @password.salt_hash = Passwd.hashing("salt")
        expect(@password.salt_text).to eq(nil)
      end

      it "@salt_hash is changed" do
        old_salt_hash = @password.salt_hash
        @password.salt_hash = Passwd.hashing("salt")
        expect(@password.salt_hash).not_to eq(old_salt_hash)
      end

      it "@hash is changed" do
        old_hash = @password.hash
        @password.salt_hash = Passwd.hashing("salt")
        expect(@password.hash).not_to eq(old_hash)
      end
    end

    context "#policy_check" do
      it "Passwd.policy_check is called with pass_text" do
        pass_text = Passwd.create
        Passwd.should_receive(:policy_check).with(pass_text)
        password = Passwd::Password.new(password: pass_text)
        password.policy_check
      end
    end

    context "#==" do
      before(:each) do
        @password = Passwd::Password.new
      end

      it "return true with valid password" do
        expect(@password == @password.text).to eq(true)
      end

      it "return false with invalid password" do
        expect(@password == "Secret!!").to eq(false)
      end
    end
  end
end