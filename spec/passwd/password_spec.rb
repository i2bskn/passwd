require "spec_helper"

describe Passwd::Password do
  let!(:pswd) { Passwd::Password.new }

  describe "#initialize" do
    context "without argument" do
      subject { Passwd::Password.new }

      it { is_expected.not_to have_attributes(plain: nil) }
      it { is_expected.not_to have_attributes(hash: nil) }
      it { is_expected.not_to have_attributes(salt: nil) }
      it { is_expected.to satisfy {|v| v.salt.is_a?(Passwd::Salt) } }
    end

    context "with plain" do
      subject { Passwd::Password.new(plain: pswd.plain) }

      it { is_expected.to have_attributes(plain: pswd.plain) }
      it { is_expected.not_to have_attributes(hash: nil) }
      it { is_expected.not_to have_attributes(salt: nil) }
      it { is_expected.to satisfy {|v| v.salt.is_a?(Passwd::Salt) } }
    end

    context "with plain and salt_plain" do
      subject { Passwd::Password.new(plain: pswd.plain, salt_plain: pswd.salt.plain) }

      it { is_expected.to have_attributes(plain: pswd.plain) }
      it { is_expected.to have_attributes(hash: pswd.hash) }
      it { is_expected.to satisfy {|v| v.salt.plain == pswd.salt.plain } }
      it { is_expected.to satisfy {|v| v.salt.hash == pswd.salt.hash } }
    end

    context "with plain and salt_hash" do
      subject { Passwd::Password.new(plain: pswd.plain, salt_hash: pswd.salt.hash) }

      it { is_expected.to have_attributes(plain: pswd.plain) }
      it { is_expected.to have_attributes(hash: pswd.hash) }
      it { is_expected.to satisfy {|v| v.salt.plain.nil? } }
      it { is_expected.to satisfy {|v| v.salt.hash == pswd.salt.hash } }
    end

    context "with hash and salt_hash" do
      subject { Passwd::Password.new(hash: pswd.hash, salt_hash: pswd.salt.hash) }

      it { is_expected.to have_attributes(plain: nil) }
      it { is_expected.to have_attributes(hash: pswd.hash) }
      it { is_expected.to satisfy {|v| v.salt.plain.nil? } }
      it { is_expected.to satisfy {|v| v.salt.hash == pswd.salt.hash } }
    end

    it {
      expect {
        Passwd::Password.new(hash: pswd.hash)
      }.to raise_error(ArgumentError)
    }
  end

  describe "#update_plain" do
    it {
      expect(pswd).to receive(:rehash)
      pswd.update_plain("secret")
      expect(pswd).to have_attributes(plain: "secret")
    }
  end

  describe "#update_hash" do
    it {
      expect {
        pswd.update_hash("hashed", "salt")
      }.to change { pswd.plain }
    }
  end
end
