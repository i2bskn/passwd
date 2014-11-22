require "spec_helper"

describe Passwd::Base do
  let(:included) { Class.new {include Passwd::Base}.new }
  let(:extended) { Class.new {extend Passwd::Base} }
  let(:plain) { "secret" }

  context "#random" do
    it { expect(included.respond_to?(:random)).to be_truthy }
    it { expect(extended.respond_to?(:random)).to be_truthy }
    it { expect(included.random.is_a?(String)).to be_truthy }
    it { expect(included.random.size).to eq(Passwd::PwConfig.length) }
    it { expect(("a".."z").to_a.include? Passwd.random(lower: false)).to be_falsey }
    it { expect(("A".."Z").to_a.include? Passwd.random(upper: false)).to be_falsey }
    it { expect(("0".."9").to_a.include? Passwd.random(number: false)).to be_falsey }

    it {
      length = Passwd::PwConfig.length + 1
      expect(included.random(length: length).size).to eq(length)
    }

    it {
      lower = ["a"]
      expect(
        included.random(letters_lower: lower, upper: false, number: false)
          .chars.uniq
      ).to eq(lower)
    }
  end

  context "#digest" do
    it { expect(included.respond_to?(:digest)).to be_truthy }
    it { expect(extended.respond_to?(:digest)).to be_truthy }
    it { expect(included.digest(plain).is_a?(String)).to be_truthy }
    it { expect(included.digest(plain)).not_to eq(plain) }

    it {
      hashed = included.send(:algorithm, Passwd::PwConfig.algorithm).hexdigest plain
      expect(Passwd.digest(plain)).to eq(hashed)
    }

    it {
      not_default = :md5
      hashed = included.send(:algorithm, not_default).hexdigest plain
      expect(Passwd.digest(plain, not_default)).to eq(hashed)
    }
  end

  context "#algorithm" do
    it { expect(included.send(:algorithm, :sha1)).to eq(Digest::SHA1) }
    it { expect(included.send(:algorithm, :sha256)).to eq(Digest::SHA256) }
    it { expect(included.send(:algorithm, :sha384)).to eq(Digest::SHA384) }
    it { expect(included.send(:algorithm, :sha512)).to eq(Digest::SHA512) }
    it { expect(included.send(:algorithm, :md5)).to eq(Digest::MD5) }
    it { expect(included.send(:algorithm, :rmd160)).to eq(Digest::RMD160) }

    it {
      expect {
        included.send(:algorithm, :unknowAn)
      }.to raise_error
    }
  end
end

