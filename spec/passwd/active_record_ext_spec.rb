require "spec_helper"

describe Passwd::ActiveRecordExt do
  context ".#with_authenticate" do
    it {expect(ActiveRecord::Base.respond_to? :with_authenticate).to be_truthy}
  end
end

