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
      expect(User.respond_to? :define_column).to be_true
    end
  end

  describe "extend methods" do
    describe ".#define_column" do
      let(:user) {User.new}

      it "define singleton methods" do
        expect(User.respond_to? :authenticate).to be_true
      end

      it "define authenticate method" do
        expect(user.respond_to? :authenticate).to be_true
      end

      it "define set_password method" do
        expect(user.respond_to? :set_password).to be_true
      end

      it "define update_password" do
        expect(user.respond_to? :update_password).to be_true
      end
    end
  end

  describe "defined methods from define_column" do
    describe ".#authenticate" do
      let!(:record) {
        record = double("record mock")
        record.stub(:salt).and_return(salt)
        record.stub(:password).and_return(password_hash)
        response = [record]
        User.stub(:where).and_return(response)
        record
      }

      it "user should be returned if authentication is successful" do
        User.should_receive(:where)
        expect(User.authenticate("valid_id", password_text)).to eq(record)
      end

      it "should return nil if authentication failed" do
        User.should_receive(:where)
        expect(User.authenticate("valid_id", "invalid_secret")).to be_nil
      end

      it "should return nil if user not found" do
        User.should_receive(:where).with(:email => "invalid_id").and_return([])
        expect(User.authenticate("invalid_id", password_text)).to be_nil
      end
    end

    describe "#authenticate" do
      let!(:user) {
        user = User.new
        user.stub(:salt).and_return(salt)
        user.stub(:password).and_return(password_hash)
        user
      }

      it "should return true if authentication is successful" do
        expect(user.authenticate(password_text)).to be_true
      end

      it "should return false if authentication failed" do
        expect(user.authenticate("invalid_pass")).to be_false
      end
    end

    describe "#set_password" do
      let!(:user) {
        user = User.new
        user.stub(:salt).and_return(salt)
        user
      }

      it "should return set password" do
        user.should_receive(:salt=).with(salt)
        user.should_receive(:password=).with(Passwd.hashing("#{salt}#{password_text}"))
        expect(user.set_password(password_text)).to eq(password_text)
      end

      it "should set random password if not specified" do
        user.should_receive(:salt=).with(salt)
        random_password = Passwd.create
        Passwd.should_receive(:create).and_return(random_password)
        user.should_receive(:password=).with(Passwd.hashing("#{salt}#{random_password}"))
        user.set_password
      end

      it "should set salt if salt is nil" do
        mail_addr = "foo@example.com"
        time_now = Time.now
        salt2 = Passwd.hashing("#{mail_addr}#{time_now.to_s}")
        Time.stub(:now).and_return(time_now)
        user.stub(:email).and_return(mail_addr)
        user.should_receive(:salt).and_return(nil)
        user.should_receive(:salt=).with(salt2)
        user.should_receive(:password=).with(Passwd.hashing("#{salt2}#{password_text}"))
        user.set_password(password_text)
      end
    end

    describe "#update_password" do
      let!(:user) {
        user = User.new
        user.stub(:salt).and_return(salt)
        user.stub(:password).and_return(password_hash)
        user
      }

      context "without policy check" do
        it "should return update password" do
          pass = "new_password"
          user.should_receive(:set_password).with(pass).and_return(pass)
          expect(user.update_password(password_text, pass)).to eq(pass)
        end

        it "should generate exception if authentication failed" do
          Passwd.should_receive(:auth).and_return(false)
          user.should_not_receive(:set_password)
          expect {
            user.update_password("invalid_password", "new_password")
          }.to raise_error(Passwd::AuthError)
        end
      end

      context "with policy check" do
        it "should return update password" do
          pass = "new_password"
          Passwd.should_receive(:policy_check).and_return(true)
          user.should_receive(:set_password).with(pass).and_return(pass)
          expect(user.update_password(password_text, pass, true)).to eq(pass)
        end

        it "should generate exception if policy not match" do
          pass = "new_password"
          Passwd.should_receive(:policy_check).and_return(false)
          expect {
            user.update_password(password_text, pass, true)
            }.to raise_error(Passwd::PolicyNotMatch)
        end
      end
    end
  end
end

