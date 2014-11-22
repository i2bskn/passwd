require "spec_helper"

describe Passwd::ActiveRecordExt do
  context ".with_authenticate" do
    it { expect(ActiveRecord::Base).to respond_to(:with_authenticate) }

    context User do
      it { is_expected.to respond_to(:passwd) }
      it { is_expected.to respond_to(:authenticate) }
      it { expect(User).to respond_to(:authenticate) }
      it { is_expected.to respond_to(:set_password) }
      it { is_expected.to respond_to(:update_password) }
    end
  end
end

