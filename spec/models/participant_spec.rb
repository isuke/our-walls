require 'spec_helper'

describe Participant do
  # TODO: use 'FactoryGirl.create(:participant)'
  let(:wall) { FactoryGirl.create(:wall) }
  let(:user) { FactoryGirl.create(:user) }
  let(:participant) { wall.participants.build(user_id: user.id) }

  subject { participant }

  it { should be_valid }
  it { should respond_to(:posts) }


  context "when a combination user and target user is already present" do
    before { participant.dup.save }

    it { should_not be_valid }
  end
end
