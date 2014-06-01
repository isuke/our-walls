require 'spec_helper'

describe Participant do
  let(:wall) { FactoryGirl.create(:wall) }
  let(:user) { FactoryGirl.create(:user) }
  let(:participant) { wall.participants.build(user_id: user.id) }

  subject { participant }

  it { should be_valid }

  context "when a combination user and target user is already present" do
    before { participant.dup.save }

    it { should_not be_valid }
  end
end
