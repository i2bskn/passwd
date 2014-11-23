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

    it {
      expect {
        pswd.update_plain("secret")
      }.to change { pswd.plain }
    }
  end

  describe "#update_hash" do
    it {
      expect(pswd).not_to receive(:rehash)
      pswd.update_hash("hashed", "salt")
      expect(pswd).to have_attributes(hash: "hashed")
      expect(pswd.salt).to have_attributes(hash: "salt")
    }

    it {
      expect {
        pswd.update_hash("hashed", "salt")
      }.to change { pswd.plain }
    }
  end

  describe "#match?" do
    it { expect(pswd.match?(pswd.plain)).to be_truthy }

    it {
      invalid = [pswd.plain, "invalid"].join
      expect(pswd.match?(invalid)).to be_falsy
    }
  end

  describe "#==" do
    it {
      expect(pswd).to receive(:match?)
      pswd == pswd.plain
    }
  end

  describe "#valid?" do
    it {
      pswd.update_plain("ValidPassw0rd")
      expect(pswd.valid?).to be_truthy
    }

    it {
      pswd.update_plain("a" * (Passwd::PwConfig.policy.min_length - 1))
      expect(pswd.valid?).to be_falsy
    }

    it {
      pswd.update_hash("hashed", "salt")
      expect {
        pswd.valid?
      }.to raise_error(Passwd::PasswdError)
    }
  end

  describe "#default_options" do
    it {
      expect(pswd.send(:default_options)).to satisfy {|v| v.has_key?(:plain) }
    }
  end

  describe "#include_char?" do
    it {
      pswd.update_plain("secret")
      expect(pswd.send(:include_char?, ["s"])).to be_truthy
    }

    it {
      expect {
        pswd.update_hash("hashed", "salt")
        pswd.send(:include_char?, [])
      }.to raise_error(Passwd::PasswdError)
    }
  end

  describe ".from_plain" do
    it {
      expect(Passwd::Password).to receive(:new)
      Passwd::Password.from_plain("secret")
    }
  end

  describe ".from_hash" do
    it {
      expect(Passwd::Password).to receive(:new)
      Passwd::Password.from_hash("hashed", "salt")
    }
  end
end
