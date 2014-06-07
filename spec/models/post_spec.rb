require 'spec_helper'

describe Post do
  let(:participant) { FactoryGirl.create(:participant) }
  let(:post)        { participant.posts.build(content: "Lorem ipsum") }

  subject { post }

  it { should be_valid }

  it { should respond_to(:participant_id) }
  it { should respond_to(:content) }
  it { should respond_to(:wall) }
  it { should respond_to(:user) }

  context "when participant id is not present" do
    before { post.participant_id = nil }
    it { should_not be_valid }
  end

  context "when content is not present" do
    before { post.content = ' ' }
    it { should_not be_valid }
  end
end
