require "spec_helper"

describe Passwd::Configuration do
  describe "#initialize" do
    subject(:config) { Passwd::PwConfig }
    # defined options
    it { expect(config.respond_to? :algorithm).to be_truthy }
    it { expect(config.respond_to? :length).to be_truthy }
    it { expect(config.respond_to? :policy).to be_truthy }
    it { expect(config.respond_to? :stretching).to be_truthy }
    it { expect(config.respond_to? :lower).to be_truthy }
    it { expect(config.respond_to? :upper).to be_truthy }
    it { expect(config.respond_to? :number).to be_truthy }
    it { expect(config.respond_to? :letters_lower).to be_truthy }
    it { expect(config.respond_to? :letters_upper).to be_truthy }
    it { expect(config.respond_to? :letters_number).to be_truthy }

    # default settings
    it { expect(config.algorithm).to eq(:sha512) }
    it { expect(config.length).to eq(8) }
    it { expect(config.policy.is_a?(Passwd::Policy)).to be_truthy }
    it { expect(config.stretching).to eq(nil) }
    it { expect(config.lower).to be_truthy }
    it { expect(config.upper).to be_truthy }
    it { expect(config.number).to be_truthy }
    it { expect(config.letters_lower).to eq(("a".."z").to_a) }
    it { expect(config.letters_upper).to eq(("A".."Z").to_a) }
    it { expect(config.letters_number).to eq(("0".."9").to_a) }
  end

  describe "Writable" do
    it {
      passwd = Class.new {extend Passwd::Configuration::Writable}
      expect(defined?(passwd::PwConfig)).to be_truthy
    }

    it { expect(Passwd.respond_to?(:configure)).to be_truthy }
    it { expect(Passwd.respond_to?(:policy_configure)).to be_truthy }
  end

  describe "Accessible" do
    let(:passwd) { Class.new {include Passwd::Configuration::Accessible} }
    it { expect(passwd::PwConfig.is_a?(Passwd::Configuration)).to be_truthy }
  end
end

