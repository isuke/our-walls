require 'spec_helper'

describe "Static pages" do

  subject { page }

  describe "Home page" do
    before { visit root_path }

    let(:signup) { 'Sign up now!' }
    let(:signin) { 'Sign in' }

    it { should     have_title('Our Walls') }
    it { should_not have_title('| Home') }
    it { should have_link(signup) }
    it { should have_link(signin) }

    describe "Sign up button" do
      before { click_link(signup) }

      it { should have_title('Sign up') }
    end

    context "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }

      before do
        visit signin_path
        fill_in "Email"   , with: user.email
        fill_in "Password", with: user.password
        click_button "Sign in"

        visit root_path
      end

      it { should have_link('Sign out') }

      context "when Sign out" do
        before { click_link('Sign out') }

        it { should have_title('Our Walls') }
        it { should have_link('Sign in') }
      end
    end
  end
end
