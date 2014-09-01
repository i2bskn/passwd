require "spec_helper"

describe Passwd::TmpConfig do
  let(:config) {Passwd::Config.instance}

  def tmp_config(options={})
    Passwd::TmpConfig.new(Passwd::Config.instance, options)
  end

  describe "defined accessors" do
    it "defined algorithm" do
      expect(config.respond_to? :algorithm).to be_truthy
    end

    it "defined length" do
      expect(tmp_config.respond_to? :length).to be_truthy
    end

    it "defined lower" do
      expect(tmp_config.respond_to? :lower).to be_truthy
    end

    it "defined upper" do
      expect(tmp_config.respond_to? :upper).to be_truthy
    end

    it "defined number" do
      expect(tmp_config.respond_to? :number).to be_truthy
    end

    it "defined letters_lower" do
      expect(tmp_config.respond_to? :letters_lower).to be_truthy
    end

    it "defined letters_upper" do
      expect(tmp_config.respond_to? :letters_upper).to be_truthy
    end

    it "defined letters_number" do
      expect(tmp_config.respond_to? :letters_number).to be_truthy
    end
  end

  describe "#initialize" do
    context "with empty options" do
      it "algorithm should be a default" do
        expect(config.algorithm).to eq(:sha512)
      end

      it "length should be a default" do
        expect(tmp_config.length).to eq(8)
      end

      it "lower should be a default" do
        expect(tmp_config.lower).to be_truthy
      end

      it "upper should be a default" do
        expect(tmp_config.upper).to be_truthy
      end

      it "number should be a default" do
        expect(tmp_config.number).to be_truthy
      end

      it "letters_lower should be a default" do
        expect(tmp_config.letters_lower).to eq(("a".."z").to_a)
      end

      it "letters_upper should be a default" do
        expect(tmp_config.letters_upper).to eq(("A".."Z").to_a)
      end

      it "letters_number should be a default" do
        expect(tmp_config.letters_number).to eq(("0".."9").to_a)
      end
    end

    context "with options" do
      it "length should be a specified params" do
        expect(tmp_config(length: 10).length).to eq(10)
        expect(config.length).to eq(8)
      end

      it "lower should be a specified params" do
        expect(tmp_config(lower: false).lower).to be_falsey
        expect(config.lower).to be_truthy
      end

      it "upper should be a specified params" do
        expect(tmp_config(upper: false).upper).to be_falsey
        expect(config.upper).to be_truthy
      end

      it "number should be a specified params" do
        expect(tmp_config(number: false).number).to be_falsey
        expect(config.number).to be_truthy
      end

      it "letters_lower should be a specified params" do
        expect(tmp_config(letters_lower: ["a"]).letters_lower).to eq(["a"])
        expect(config.letters_lower).to eq(("a".."z").to_a)
      end

      it "letters_upper should be a specified params" do
        expect(tmp_config(letters_upper: ["A"]).letters_upper).to eq(["A"])
        expect(config.letters_upper).to eq(("A".."Z").to_a)
      end

      it "letters_number should be a specified params" do
        expect(tmp_config(letters_number: ["0"]).letters_number).to eq(["0"])
        expect(config.letters_number).to eq(("0".."9").to_a)
      end
    end
  end

  describe "#configure" do
    let(:changed_tmp_config) do
      tconf = tmp_config
      tconf.configure do |c|
        c.length = 20
        c.lower = false
        c.upper = false
        c.number = false
        c.letters_lower = ["a"]
        c.letters_upper = ["A"]
        c.letters_number = ["0"]
      end
      tconf
    end

    it "set length from block" do
      expect(changed_tmp_config.length).to eq(20)
      expect(config.length).to eq(8)
    end

    it "set lower from block" do
      expect(changed_tmp_config.lower).to be_falsey
      expect(config.lower).to be_truthy
    end

    it "set upper from block" do
      expect(changed_tmp_config.upper).to be_falsey
      expect(config.upper).to be_truthy
    end

    it "set number from block" do
      expect(changed_tmp_config.number).to be_falsey
      expect(config.number).to be_truthy
    end

    it "set letters_lower from block" do
      expect(changed_tmp_config.letters_lower).to eq(["a"])
      expect(config.letters_lower).to eq(("a".."z").to_a)
    end

    it "set letters_upper from block" do
      expect(changed_tmp_config.letters_upper).to eq(["A"])
      expect(config.letters_upper).to eq(("A".."Z").to_a)
    end

    it "set letters_number from block" do
      expect(changed_tmp_config.letters_number).to eq(["0"])
      expect(config.letters_number).to eq(("0".."9").to_a)
    end

    it "raise error unknown setting" do
      expect {
        tmp_config.configure do |c|
          c.unknown = true
        end
      }.to raise_error
    end
  end

  describe "#merge" do
    let(:default_tmp_config) {tmp_config}

    it "set length from hash" do
      default_tmp_config.merge(length: 10)
      expect(default_tmp_config.length).to eq(10)
      expect(config.length).to eq(8)
    end

    it "set lower from hash" do
      default_tmp_config.merge(lower: false)
      expect(default_tmp_config.lower).to be_falsey
      expect(config.lower).to be_truthy
    end

    it "set upper from hash" do
      default_tmp_config.merge(upper: false)
      expect(default_tmp_config.upper).to be_falsey
      expect(config.upper).to be_truthy
    end

    it "set number from hash" do
      default_tmp_config.merge(number: false)
      expect(default_tmp_config.number).to be_falsey
      expect(config.number).to be_truthy
    end

    it "set letters_lower from hash" do
      default_tmp_config.merge(letters_lower: ["a"])
      expect(default_tmp_config.letters_lower).to eq(["a"])
      expect(config.letters_lower).to eq(("a".."z").to_a)
    end

    it "set letters_upper from hash" do
      default_tmp_config.merge(letters_upper: ["A"])
      expect(default_tmp_config.letters_upper).to eq(["A"])
      expect(config.letters_upper).to eq(("A".."Z").to_a)
    end

    it "set letters_number from hash" do
      default_tmp_config.merge(letters_number: ["0"])
      expect(default_tmp_config.letters_number).to eq(["0"])
      expect(config.letters_number).to eq(("0".."9").to_a)
    end

    it "raise error unknown setting" do
      expect {
        tmp_config.merge(unknown: true)
      }.to raise_error
    end
  end

  describe "#letters" do
    it "return Array object" do
      expect(tmp_config.letters.is_a? Array).to be_truthy
    end

    it "all elements of the string" do
      tmp_config.letters.each do |l|
        expect(l.is_a? String).to be_truthy
      end
    end

    it "return all letters" do
      all_letters = ("a".."z").to_a.concat(("A".."Z").to_a).concat(("0".."9").to_a)
      expect(tmp_config.letters).to eq(all_letters)
    end

    it "return except for the lower case" do
      expect(tmp_config(lower: false).letters.include? "a").to be_falsey
    end

    it "return except for the upper case" do
      expect(tmp_config(upper: false).letters.include? "A").to be_falsey
    end

    it "return except for the number case" do
      expect(tmp_config(number: false).letters.include? "0").to be_falsey
    end

    it "raise error if letters is empty" do
      tconf = tmp_config(lower: false, upper: false, number: false)
      expect {
        tconf.letters
      }.to raise_error
    end
  end
end

