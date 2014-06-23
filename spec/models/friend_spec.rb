require 'spec_helper'

describe Friend do
  let(:user)        { FactoryGirl.create(:user) }
  let(:target_user) { FactoryGirl.create(:user) }
  let(:friend)      { FactoryGirl.build(:friend, user_id: user.id, target_user_id: target_user.id) }

  subject { friend }

  it { should be_valid }

  it { should respond_to(:target_user) }
  its(:target_user) { should eq target_user }

  describe "when user id is not present" do
    before { friend.user_id = nil }
    it { should_not be_valid }
  end

  describe "when target user id is not present" do
    before { friend.target_user_id = nil }
    it { should_not be_valid }
  end

  context "when a combination user and target user is already present" do
    before { friend.dup.save }

    it { should_not be_valid }
  end

  context "when a combination user and target user is not already present" do
    let(:other_user) { FactoryGirl.create(:user) }

    before do
      other_friend = friend.dup
      other_friend.user_id = other_user.id
      other_friend.save
    end

    it { should be_valid }
  end

  context "when a combination user and target user is not already present" do
    let(:other_user) { FactoryGirl.create(:user) }

    before do
      other_friend = friend.dup
      other_friend.target_user_id = other_user.id
      other_friend.save
    end

    it { should be_valid }
  end
end
