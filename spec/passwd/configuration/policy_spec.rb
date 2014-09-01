require "spec_helper"

describe Passwd::Policy do
  let(:policy) {Passwd::Policy.instance}

  describe "defined accessors" do
    it "defined min_length" do
      expect(policy.respond_to? :min_length).to be_truthy
    end

    it "defined require_lower" do
      expect(policy.respond_to? :require_lower).to be_truthy
    end

    it "defined require_upper" do
      expect(policy.respond_to? :require_upper).to be_truthy
    end

    it "defined require_number" do
      expect(policy.respond_to? :require_number).to be_truthy
    end
  end

  describe "#initialize" do
    it "min_length should be a default" do
      expect(policy.min_length).to eq(8)
    end

    it "require_lower should be a default" do
      expect(policy.require_lower).to be_truthy
    end

    it "require_upper should be a default" do
      expect(policy.require_upper).to be_falsey
    end

    it "require_number should be a default" do
      expect(policy.require_number).to be_truthy
    end
  end

  describe "#configure" do
    before {
      policy.configure do |c|
        c.min_length = 20
        c.require_lower = false
        c.require_upper = true
        c.require_number = false
      end
    }

    it "set min_length from block" do
      expect(policy.min_length).to eq(20)
    end

    it "set require_lower from block" do
      expect(policy.require_lower).to be_falsey
    end

    it "set require_upper from block" do
      expect(policy.require_upper).to be_truthy
    end

    it "set require_number from block" do
      expect(policy.require_number).to be_falsey
    end
  end

  describe "#valid?" do
    let(:config) {Passwd::Config.instance}

    it "valid password should be valid" do
      expect(policy.valid?("secret1234", config)).to be_truthy
    end

    it "short password should not valid" do
      expect(policy.valid?("short1", config)).to be_falsey
    end

    it "password should not valid if not contain lower case" do
      expect(policy.valid?("NOTLOWER12", config)).to be_falsey
    end

    it "password should not valid if not contain upper case" do
      policy.configure {|c| c.require_upper = true}
      expect(policy.valid?("notupper12", config)).to be_falsey
    end

    it "password should not valid if not contain number" do
      expect(policy.valid?("notnumber", config)).to be_falsey
    end
  end

  describe "#include_char?" do
    it "should be return true if contains" do
      expect(policy.include_char?(("a".."z").to_a, "contains")).to be_truthy
    end

    it "should be return false if not contains" do
      expect(policy.include_char?(("a".."z").to_a, "NOTCONTAINS")).to be_falsey
    end
  end

  describe "#reset" do
    before {
      policy.configure do |c|
        c.min_length = 20
        c.require_lower = false
        c.require_upper = true
        c.require_number = false
      end
      policy.reset
    }

    it "min_length should be a default" do
      expect(policy.min_length).to eq(8)
    end

    it "require_lower should be a default" do
      expect(policy.require_lower).to be_truthy
    end

    it "require_upper should be a default" do
      expect(policy.require_upper).to be_falsey
    end

    it "require_number should be a default" do
      expect(policy.require_number).to be_truthy
    end
  end
end

