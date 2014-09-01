require "spec_helper"

describe Passwd::ActiveRecord do
  class User
    include Passwd::ActiveRecord
    define_column
  end

  let(:salt) {Digest::SHA512.hexdigest("salt")}
  let(:password_text) {"secret"}
  let(:password_hash) {Digest::SHA512.hexdigest("#{salt}#{password_text}")}

  describe ".#included" do
    it "define singleton methods" do
      expect(User.respond_to? :define_column).to be_truthy
    end
  end

  describe "extend methods" do
    describe ".#define_column" do
      let(:user) {User.new}

      it "define singleton methods" do
        expect(User.respond_to? :authenticate).to be_truthy
      end

      it "define authenticate method" do
        expect(user.respond_to? :authenticate).to be_truthy
      end

      it "define set_password method" do
        expect(user.respond_to? :set_password).to be_truthy
      end

      it "define update_password" do
        expect(user.respond_to? :update_password).to be_truthy
      end
    end
  end

  describe "defined methods from define_column" do
    describe ".#authenticate" do
      let!(:record) {
        record = double("record mock")
        allow(record).to receive_messages(salt: salt, password: password_hash)
        response = [record]
        allow(User).to receive(:where) {response}
        record
      }

      it "user should be returned if authentication is successful" do
        expect(User).to receive(:where)
        expect(User.authenticate("valid_id", password_text)).to eq(record)
      end

      it "should return nil if authentication failed" do
        expect(User).to receive(:where)
        expect(User.authenticate("valid_id", "invalid_secret")).to be_nil
      end

      it "should return nil if user not found" do
        expect(User).to receive(:where).with(email: "invalid_id") {[]}
        expect(User.authenticate("invalid_id", password_text)).to be_nil
      end
    end

    describe "#authenticate" do
      let!(:user) {
        user = User.new
        allow(user).to receive_messages(salt: salt, password: password_hash)
        user
      }

      it "should return true if authentication is successful" do
        expect(user.authenticate(password_text)).to be_truthy
      end

      it "should return false if authentication failed" do
        expect(user.authenticate("invalid_pass")).to be_falsey
      end
    end

    describe "#set_password" do
      let!(:user) {
        user = User.new
        allow(user).to receive(:salt) {salt}
        user
      }

      it "should return set password" do
        expect(user).to receive(:salt=).with(salt)
        expect(user).to receive(:password=).with(Passwd.hashing("#{salt}#{password_text}"))
        expect(user.set_password(password_text)).to eq(password_text)
      end

      it "should set random password if not specified" do
        expect(user).to receive(:salt=).with(salt)
        random_password = Passwd.create
        expect(Passwd).to receive(:create) {random_password}
        expect(user).to receive(:password=).with(Passwd.hashing("#{salt}#{random_password}"))
        user.set_password
      end

      it "should set salt if salt is nil" do
        mail_addr = "foo@example.com"
        time_now = Time.now
        salt2 = Passwd.hashing("#{mail_addr}#{time_now.to_s}")
        allow(Time).to receive(:now) {time_now}
        allow(user).to receive(:email) {mail_addr}
        expect(user).to receive(:salt) {nil}
        expect(user).to receive(:salt=).with(salt2)
        expect(user).to receive(:password=).with(Passwd.hashing("#{salt2}#{password_text}"))
        user.set_password(password_text)
      end
    end

    describe "#update_password" do
      let!(:user) {
        user = User.new
        allow(user).to receive(:salt) {salt}
        allow(user).to receive(:password) {password_hash}
        user
      }

      context "without policy check" do
        it "should return update password" do
          pass = "new_password"
          expect(user).to receive(:set_password).with(pass) {pass}
          expect(user.update_password(password_text, pass)).to eq(pass)
        end

        it "should generate exception if authentication failed" do
          expect(Passwd).to receive(:auth) {false}
          expect(user).not_to receive(:set_password)
          expect {
            user.update_password("invalid_password", "new_password")
          }.to raise_error(Passwd::AuthError)
        end
      end

      context "with policy check" do
        it "should return update password" do
          pass = "new_password"
          expect(Passwd).to receive(:policy_check) {true}
          expect(user).to receive(:set_password).with(pass) {pass}
          expect(user.update_password(password_text, pass, true)).to eq(pass)
        end

        it "should generate exception if policy not match" do
          pass = "new_password"
          expect(Passwd).to receive(:policy_check) {false}
          expect {
            user.update_password(password_text, pass, true)
            }.to raise_error(Passwd::PolicyNotMatch)
        end
      end
    end
  end
end
