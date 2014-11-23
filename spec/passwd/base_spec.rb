require "spec_helper"

describe Passwd::Base do
  let(:plain) { "secret" }

  context "#random" do
    it { expect(Passwd).to respond_to(:random) }
    it { expect(Passwd.random.is_a?(String)).to be_truthy }
    it { expect(Passwd.random.size).to eq(Passwd::PwConfig.length) }
    it { expect(Passwd.random(lower: false)).not_to include(*"a".."z") }
    it { expect(Passwd.random(upper: false)).not_to include(*"A".."Z") }
    it { expect(Passwd.random(number: false)).not_to include(*"0".."9") }

    it {
      length = Passwd::PwConfig.length + 1
      expect(Passwd.random(length: length).size).to eq(length)
    }

    it {
      lower = ["a"]
      expect(
        Passwd.random(letters_lower: lower, upper: false, number: false)
          .chars.uniq
      ).to eq(lower)
    }
  end

  context "#digest" do
    it { expect(Passwd.respond_to?(:digest)).to be_truthy }
    it { expect(Passwd.digest(plain).is_a?(String)).to be_truthy }
    it { expect(Passwd.digest(plain)).not_to eq(plain) }

    it {
      hashed = Passwd.send(:algorithm, Passwd::PwConfig.algorithm).hexdigest plain
      expect(Passwd.digest(plain)).to eq(hashed)
    }

    it {
      not_default = :md5
      hashed = Passwd.send(:algorithm, not_default).hexdigest plain
      expect(Passwd.digest(plain, not_default)).to eq(hashed)
    }
  end

  context "#algorithm" do
    it { expect(Passwd.send(:algorithm, :sha1)).to eq(Digest::SHA1) }
    it { expect(Passwd.send(:algorithm, :sha256)).to eq(Digest::SHA256) }
    it { expect(Passwd.send(:algorithm, :sha384)).to eq(Digest::SHA384) }
    it { expect(Passwd.send(:algorithm, :sha512)).to eq(Digest::SHA512) }
    it { expect(Passwd.send(:algorithm, :md5)).to eq(Digest::MD5) }
    it { expect(Passwd.send(:algorithm, :rmd160)).to eq(Digest::RMD160) }

    it {
      expect {
        Passwd.send(:algorithm, :unknowAn)
      }.to raise_error
    }
  end
end

