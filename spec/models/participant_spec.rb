require 'spec_helper'

describe Participant do
  let(:wall) { FactoryGirl.create(:wall) }
  let(:user) { FactoryGirl.create(:user) }
  let(:participant) do
    FactoryGirl.build(:owner, wall_id: wall.id, user_id: user.id)
  end

  subject { participant }

  it { should be_valid }
  it { should respond_to(:posts) }
  it { should respond_to(:owner?) }

  its(:owner?) { should be_true }

  context "when a combination user and target user is already present" do
    before { participant.dup.save }

    it { should_not be_valid }
  end
end
