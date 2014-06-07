require 'spec_helper'

describe "Wall pages" do

  subject { page }

  describe "new" do

    context "when signed-in user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:submit) { 'Create new wall' }

      before do
        sign_in user
        visit new_wall_path user
      end

      it { should have_title('Create Wall') }

      context "with invalid information" do
        it "should not create a wall" do
          expect { click_button submit }.not_to change(Wall, :count)
        end

        context "after submission" do
          before { click_button submit }

          it { should have_title('Create Wall') }
          it { should have_selector('div.alert.alert-danger', text: 'error') }
        end
      end

      context "with valid information" do
        before { fill_in "Name", with: "Example Wall" }

        it "should create a wall" do
          expect { click_button submit }.to change(Wall, :count).by(1)
        end

        it "should create a participant" do
          expect { click_button submit }.to change(Participant, :count).by(1)
        end

        context "after save the wall" do
          before { click_button submit }

          it { should have_title(user.name) }
          it { should have_selector('div.alert.alert-success', text: 'Example Wall') }
        end
      end
    end

    context "when unsigned-in user" do
      let(:user) { FactoryGirl.create(:user) }
      before { visit new_wall_path user }

      it { should have_title('Sign in') }
      it { should have_selector('div.alert.alert-warning',
                                text: 'Please sign in.') }
    end

  end

  describe "show" do
    let(:wall)         { FactoryGirl.create(:wall) }
    let(:user1)        { FactoryGirl.create(:user) }
    let(:user2)        { FactoryGirl.create(:user) }
    let(:friend_user1) { FactoryGirl.create(:user) }
    let(:friend_user2) { FactoryGirl.create(:user) }

    before do

      wall.participate(user1).save
      wall.participate(user2).save
      user1.make_friend(friend_user1)
      user1.make_friend(friend_user2)

      sign_in user1
      visit wall_path(wall)
    end

    it { should have_title(wall.name) }
    it { should have_content("Participating Users(#{wall.users.count})") }

    it "should list each users" do
      wall.users.each do |u|
        expect(page).to have_selector('li', text: u.name)
      end
    end

    it "shuld list each friend users" do
      user1.friend_users do |u|
        expect(page).to have_selector('li', text: u.name)
      end
    end

    context "when click leave button" do
      it "should decrement participant" do
        expect do
          click_button 'Leave', match: :first
        end.to change(Participant, :count).by(-1)
      end
    end

    context "when click invite button" do
      it "should increment participant" do
        expect do
          click_button 'Invite', match: :first
        end.to change(Participant, :count).by(1)
      end
    end
  end

end