require "spec_helper"

describe Passwd::ActiveRecordExt do
  describe ".with_authenticate" do
    it { expect(ActiveRecord::Base).to respond_to(:with_authenticate) }

    context User do
      let(:new_pass) { "NewPassw0rd" }
      let(:password) { Passwd::Password.new }
      let(:user) {
        User.create(
          name: "i2bskn",
          email: "i2bskn@example.com",
          salt: password.salt.hash,
          password: password.hash
        )
      }

      it { is_expected.to respond_to(:passwd) }
      it { is_expected.to respond_to(:authenticate) }
      it { expect(User).to respond_to(:authenticate) }
      it { is_expected.to respond_to(:set_password) }
      it { is_expected.to respond_to(:update_password) }

      context "#passwd" do
        after { user.passwd }

        it { expect(user.passwd.is_a?(Passwd::Password)).to be_truthy }
        it { expect(user).to receive(:reload) }
        it { expect(Passwd::Password).to receive(:from_hash) }

        it {
          user = User.new
          expect(user).to receive(:set_password)
          user.passwd
        }
      end

      context ".authenticate" do
        before { user }

        it { expect(User.authenticate("i2bskn@example.com", password.plain)).not_to be_falsy }
        it { expect(User.authenticate("i2bskn@example.com", "invalid")).to be_falsy }
      end

      context "#authenticate" do
        it { expect(user.authenticate(password.plain)).not_to be_falsy }
        it { expect(user.authenticate("invalid")).to be_falsy }
      end

      context "#set_password" do
        it { expect { user.set_password }.to change { user.password } }
        it { expect { user.set_password(new_pass) }.to change { user.password } }
      end

      context "#update_password" do
        before { user }

        it {
          expect {
            user.update_password(password.plain, new_pass)
          }.to change { user.password }
        }

        it {
          expect {
            user.update_password(password.plain, "secret", true)
          }.to raise_error(Passwd::PolicyNotMatch)
        }

        it {
          expect {
            user.update_password("invalid", new_pass)
          }.to raise_error(Passwd::AuthenticationFails)
        }
      end
    end
  end
end

