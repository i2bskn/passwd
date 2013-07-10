# coding: utf-8

require "spec_helper"

describe Passwd::Config do
  let(:config) {Passwd::Config.instance}
  before {config.reset}

  describe "defined accessors" do
    it "defined length" do
      expect(config.respond_to? :length).to be_true
    end

    it "defined lower" do
      expect(config.respond_to? :lower).to be_true
    end

    it "defined upper" do
      expect(config.respond_to? :upper).to be_true
    end

    it "defined number" do
      expect(config.respond_to? :number).to be_true
    end

    it "defined letters_lower" do
      expect(config.respond_to? :letters_lower).to be_true
    end

    it "defined letters_upper" do
      expect(config.respond_to? :letters_upper).to be_true
    end

    it "defined letters_number" do
      expect(config.respond_to? :letters_number).to be_true
    end
  end

  describe "#initialize" do
    it "length should be a default" do
      expect(config.length).to eq(8)
    end

    it "lower should be a default" do
      expect(config.lower).to be_true
    end

    it "upper should be a default" do
      expect(config.upper).to be_true
    end

    it "number should be a default" do
      expect(config.number).to be_true
    end

    it "letters_lower should be a default" do
      expect(config.letters_lower).to eq(("a".."z").to_a)
    end

    it "letters_upper should be a default" do
      expect(config.letters_upper).to eq(("A".."Z").to_a)
    end

    it "letters_number should be a default" do
      expect(config.letters_number).to eq(("0".."9").to_a)
    end
  end

  describe "#configure" do
    before {
      config.configure do |c|
        c.length = 20
        c.lower = false
        c.upper = false
        c.number = false
        c.letters_lower = ["a"]
        c.letters_upper = ["A"]
        c.letters_number = ["0"]
      end
    }

    it "set length from block" do
      expect(config.length).to eq(20)
    end

    it "set lower from block" do
      expect(config.lower).to be_false
    end

    it "set upper from block" do
      expect(config.upper).to be_false
    end

    it "set number from block" do
      expect(config.number).to be_false
    end

    it "set letters_lower from block" do
      expect(config.letters_lower).to eq(["a"])
    end

    it "set letters_upper from block" do
      expect(config.letters_upper).to eq(["A"])
    end

    it "set letters_number from block" do
      expect(config.letters_number).to eq(["0"])
    end

    it "raise error unknown setting" do
      expect {
        config.configure do |c|
          c.unknown = true
        end
      }.to raise_error
    end
  end

  describe "#merge" do
    it "set length from hash" do
      config.merge(length: 10)
      expect(config.length).to eq(10)
    end

    it "set lower from hash" do
      config.merge(lower: false)
      expect(config.lower).to be_false
    end

    it "set upper from hash" do
      config.merge(upper: false)
      expect(config.upper).to be_false
    end

    it "set number from hash" do
      config.merge(number: false)
      expect(config.number).to be_false
    end

    it "set letters_lower from hash" do
      config.merge(letters_lower: ["a"])
      expect(config.letters_lower).to eq(["a"])
    end

    it "set letters_upper from hash" do
      config.merge(letters_upper: ["A"])
      expect(config.letters_upper).to eq(["A"])
    end

    it "set letters_number from hash" do
      config.merge(letters_number: ["0"])
      expect(config.letters_number).to eq(["0"])
    end

    it "raise error unknown setting" do
      expect {
        config.merge(unknown: true)
      }.to raise_error
    end
  end

  describe "#letters" do
    it "return Array object" do
      expect(config.letters.is_a? Array).to be_true
    end

    it "all elements of the string" do
      config.letters.each do |l|
        expect(l.is_a? String).to be_true
      end
    end

    it "return all letters" do
      all_letters = ("a".."z").to_a.concat(("A".."Z").to_a).concat(("0".."9").to_a)
      expect(config.letters).to eq(all_letters)
    end

    it "return except for the lower case" do
      config.merge(lower: false)
      expect(config.letters.include? "a").to be_false
    end

    it "return except for the upper case" do
      config.merge(upper: false)
      expect(config.letters.include? "A").to be_false
    end

    it "return except for the number case" do
      config.merge(number: false)
      expect(config.letters.include? "0").to be_false
    end

    it "raise error if letters is empty" do
      config.merge(lower: false, upper: false, number: false)
      expect {
        config.letters
      }.to raise_error
    end
  end

  describe "#reset" do
    before {
      config.configure do |c|
        c.length = 20
        c.lower = false
        c.upper = false
        c.number = false
        c.letters_lower = ["a"]
        c.letters_upper = ["A"]
        c.letters_number = ["0"]
      end
      config.reset
    }

    it "length should be a default" do
      expect(config.length).to eq(8)
    end

    it "lower should be a default" do
      expect(config.lower).to be_true
    end

    it "upper should be a default" do
      expect(config.upper).to be_true
    end

    it "number should be a default" do
      expect(config.number).to be_true
    end

    it "letters_lower should be a default" do
      expect(config.letters_lower).to eq(("a".."z").to_a)
    end

    it "letters_upper should be a default" do
      expect(config.letters_upper).to eq(("A".."Z").to_a)
    end

    it "letters_number should be a default" do
      expect(config.letters_number).to eq(("0".."9").to_a)
    end
  end
end
