require "spec_helper"

describe Passwd::Configuration do
  describe "#initialize" do
    subject { Passwd::PwConfig }
    # defined options
    it { is_expected.to respond_to(:algorithm) }
    it { is_expected.to respond_to(:length) }
    it { is_expected.to respond_to(:policy) }
    it { is_expected.to respond_to(:stretching) }
    it { is_expected.to respond_to(:lower) }
    it { is_expected.to respond_to(:upper) }
    it { is_expected.to respond_to(:number) }
    it { is_expected.to respond_to(:letters_lower) }
    it { is_expected.to respond_to(:letters_upper) }
    it { is_expected.to respond_to(:letters_number) }

    # default settings
    it { is_expected.to have_attributes(algorithm: :sha512) }
    it { is_expected.to have_attributes(length: 8) }
    it { is_expected.to satisfy {|v| v.policy.is_a?(Passwd::Policy) } }
    it { is_expected.to have_attributes(stretching: nil) }
    it { is_expected.to have_attributes(lower: true) }
    it { is_expected.to have_attributes(upper: true) }
    it { is_expected.to have_attributes(number: true) }
    it { is_expected.to have_attributes(letters_lower: [*"a".."z"]) }
    it { is_expected.to have_attributes(letters_upper: [*"A".."Z"]) }
    it { is_expected.to have_attributes(letters_number: [*"0".."9"]) }
  end

  describe "Writable" do
    subject { Passwd }

    it {
      klass = Class.new { extend Passwd::Configuration::Writable }
      expect(defined?(klass::PwConfig)).to be_truthy
    }

    it { is_expected.to respond_to(:configure) }
    it { is_expected.to respond_to(:policy_configure) }
  end

  describe "Accessible" do
    it {
      klass = Class.new { include Passwd::Configuration::Accessible }
      expect(klass::PwConfig.is_a?(Passwd::Configuration)).to be_truthy
    }
  end
end

