require "spec_helper"

describe Passwd::ActiveRecordExt do
  context ".#with_authenticate" do
    it { expect(ActiveRecord::Base.respond_to? :with_authenticate).to be_truthy }
  end

  describe User do
    it { is_expected.to respond_to(:passwd) }
    it { is_expected.to respond_to(:authenticate) }
    it { expect(User).to respond_to(:authenticate) }
    it { is_expected.to respond_to(:set_password) }
    it { is_expected.to respond_to(:update_password) }
  end
end

