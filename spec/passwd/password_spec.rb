require "spec_helper"

describe Passwd::Password do
  let(:password) {Passwd::Password.new}

  describe "#initialize" do
    context "with default params" do
      let!(:password_text) {
        password_text = Passwd.create
        Passwd.should_receive(:create).and_return(password_text)
        password_text
      }

      let!(:time_now) {
        time_now = Time.now
        Time.should_receive(:now).and_return(time_now)
        time_now
      }

      it "@text should be a random password" do
        expect(password.text.size).to eq(8)
        expect(password.text).to eq(password_text)
      end

      it "@salt_text should be a auto created" do
        expect(password.salt_text).to eq(time_now.to_s)
      end

      it "@salt_hash should be a hashed salt" do
        expect(password.salt_hash).to eq(Passwd.hashing(time_now.to_s))
      end

      it "@password_hash should be a hashed password with salt" do
        password_hash = Passwd.hashing("#{Passwd.hashing(time_now.to_s)}#{password_text}")
        expect(password.hash).to eq(password_hash)
      end
    end

    context "with custom params" do
      let(:password_text) {Passwd.create}
      let(:salt_text) {"salt"}
      let!(:time_now) {
        time_now = Time.now
        Time.stub(:create).and_return(time_now)
        time_now
      }

      it "@text is specified password" do
        password = Passwd::Password.new(password: password_text)
        expect(password.text).to eq(password_text)
      end

      it "@hash is hash of specified password" do
        password = Passwd::Password.new(password: password_text)
        password_hash = Passwd.hashing("#{Passwd.hashing(time_now.to_s)}#{password_text}")
        expect(password.hash).to eq(password_hash)
      end

      it "@salt_text is specified salt" do
        password = Passwd::Password.new(salt_text: salt_text)
        expect(password.salt_text).to eq(salt_text)
      end

      it "@salt_hash is hash of specified salt" do
        salt_hash = Passwd.hashing(salt_text)
        password = Passwd::Password.new(salt_text: salt_text)
        expect(password.salt_hash).to eq(salt_hash)
      end
    end
  end

  describe "#text=" do
    it "@text is changed" do
      old_password = password.text
      password.text = password.text.reverse
      expect(password.text).not_to eq(old_password)
    end

    it "@hash is changed" do
      old_hash = password.hash
      new_password = password.text = password.text.reverse
      expect(password.hash).not_to eq(old_hash)
      expect(password.hash).to eq(Passwd.hashing("#{password.salt_hash}#{new_password}"))
    end
  end

  describe "#hash=" do
    it "@text is nil" do
      password.hash = Passwd.hashing("secret")
      expect(password.text).to be_nil
    end

    it "@hash is changed" do
      old_hash = password.hash
      password.hash = Passwd.hashing("secret")
      expect(password.hash).not_to eq(old_hash)
    end
  end

  describe "#salt_text=" do
    it "@salt_text is changed" do
      old_salt = password.salt_text
      password.salt_text = "salt"
      expect(password.salt_text).not_to eq(old_salt)
    end

    it "@salt_hash is changed" do
      old_salt = password.salt_hash
      password.salt_text = "salt"
      expect(password.salt_hash).not_to eq(old_salt)
    end

    it "@hash is changed" do
      old_hash = password.hash
      password.salt_text = "salt"
      expect(password.hash).not_to eq(old_hash)
    end
  end

  describe "#salt_hash=" do
    it "@salt_text is nil" do
      password.salt_hash = Passwd.hashing("salt")
      expect(password.salt_text).to eq(nil)
    end

    it "@salt_hash is changed" do
      old_salt_hash = password.salt_hash
      password.salt_hash = Passwd.hashing("salt")
      expect(password.salt_hash).not_to eq(old_salt_hash)
    end

    it "@hash is changed" do
      old_hash = password.hash
      password.salt_hash = Passwd.hashing("salt")
      expect(password.hash).not_to eq(old_hash)
    end
  end

  describe "#==" do
    it "return true with valid password" do
      expect(password == password.text).to be_true
    end

    it "return false with invalid password" do
      expect(password == "secret").to be_false
    end
  end
end

