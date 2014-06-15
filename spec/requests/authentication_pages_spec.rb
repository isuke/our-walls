require 'spec_helper'

describe "Authentication" do

  subject{ page }

  describe "signin page" do
    before { visit signin_path }

    it { should have_title('Sign in') }
    it { should have_button('Sign in') }

    context "with invalid information" do
      before { click_button('Sign in') }

      it { should have_title('Sign in') }
      it { should have_selector('div.alert.alert-danger', 'Invalid') }
    end

    context "with valid information" do
      let(:user) { FactoryGirl.create(:user) }

      before do
        fill_in "Email"   , with: user.email.upcase
        fill_in "Password", with: user.password
        click_button('Sign in')
      end

      it { should have_title(user.name) }
      it { should_not have_button('Sign in') }
    end
  end
end
