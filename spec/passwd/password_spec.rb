# coding: utf-8

require "spec_helper"

describe Passwd do
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