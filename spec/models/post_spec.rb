require 'spec_helper'

describe Post do
  let(:user) { FactoryGirl.create(:user) }
  let(:wall) { FactoryGirl.create(:wall) }
  let(:participant) do
    FactoryGirl.create(:owner, wall_id: wall.id, user_id: user.id)
  end
  let(:post) do
    FactoryGirl.build(:post,
                      participant_id: participant.id,
                      content: "Lorem ipsum")
  end

  subject { post }

  it { should be_valid }

  it { should respond_to(:participant_id) }
  it { should respond_to(:content) }
  it { should respond_to(:wall) }
  it { should respond_to(:user) }

  its(:content) { should eq "Lorem ipsum" }
  its(:wall)    { should eq wall }
  its(:user)    { should eq user }

  context "when participant id is not present" do
    before { post.participant_id = nil }
    it { should_not be_valid }
  end

  context "when content is not present" do
    before { post.content = ' ' }
    it { should_not be_valid }
  end
end
