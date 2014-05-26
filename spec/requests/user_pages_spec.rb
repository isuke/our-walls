require 'spec_helper'

describe "User pages" do

  subject { page }

  describe "sginup" do
    before { visit signup_path }

    let(:submit) { "Create my account" }

    context "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end

      context "after submission" do
        before { click_button submit }

        it { should have_title('Sign up') }
        it { should have_selector('div.alert.alert-danger', text: 'error') }
      end
    end

    context "with valid information" do
      before do
        fill_in "Name",             with: "Example User"
        fill_in "Email",            with: "user@example.com"
        fill_in "Password",         with: "foobar"
        fill_in "Confirm Password", with: "foobar"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      context "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by(email: 'user@example.com') }

        it { should have_title(user.name) }
        it { should have_selector('div.alert.alert-success', text: 'Welcome') }
      end
    end
  end

  describe "user info page" do
    let(:user) { FactoryGirl.create(:user) }

    before { visit user_path(user) }

    it { should have_title(user.name)}

    describe "delete link" do

      it { should have_link('delete')}
      it "should be able to delete the user" do
        expect do
          click_link('delete')
        end.to change(User, :count).by(-1)
      end

      context "after delete the user" do
        before { click_link('delete') }

        it {should have_title('Our Walls')}
      end

    end
  end
end
