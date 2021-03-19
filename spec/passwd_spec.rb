require "spec_helper"

RSpec.describe Passwd do
  it "has a version number" do
    expect(Passwd::VERSION).not_to be nil
  end
end
