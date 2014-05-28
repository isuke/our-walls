require 'spec_helper'

describe FriendsController do
  let(:user)       { FactoryGirl.create(:user) }
  let(:other_user) { FactoryGirl.create(:user) }

  before { sign_in user, no_capybara: true }

  describe "creating a friend with Ajax" do

    it "should increment the Friend count" do
      expect do
        xhr :post, :create, friend: { target_user_id: other_user.id }
      end.to change(Friend, :count).by(1)
    end
  end

  describe "delete a friend with Ajax" do
    before { user.make_friend(other_user) }
    let(:friend) { user.friends.find_by(target_user_id: other_user.id) }
    it "should decrement the Friend count" do
      expect do
        xhr :delete, :destroy, id: friend.id
      end.to change(Friend, :count).by(-1)
    end
  end

end
