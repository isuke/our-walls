require 'spec_helper'

describe FriendsController do
  let(:user)       { FactoryGirl.create(:user) }
  let(:other_user) { FactoryGirl.create(:user) }

  before do
    # TODO
    # Capybaraを使用せずにログインする
    remember_token = User.new_remember_token
    cookies[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.encrypt(remember_token))
  end

  describe "creating a friend with Ajax" do

    it "should increment the Friend count" do
      expect do
        xhr :post, :create, friend: { target_user_id: other_user.id }
      end.to change(Friend, :count).by(1)
    end
  end
end
