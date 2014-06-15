require 'spec_helper'

describe "Static pages" do

  subject { page }

  describe "Header" do
    before { visit root_path }
    let(:signin) { 'Sign in' }

    it { should have_link('Home') }

    context "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }

      before do
        sign_in user
        visit root_path
      end

      it { should have_link('Users')}
      it { should have_link(user.name)}
      it { should have_link('Sign out') }

      context "when Sign out" do
        before { click_link('Sign out') }

        it { should have_title('Our Walls') }
        it { should have_link(signin) }
      end
    end
  end

  describe "Home page" do
    before { visit root_path }

    let(:signup) { 'Sign up now!' }

    it { should     have_title('Our Walls') }
    it { should_not have_title('| Home') }
    it { should have_link(signup) }

    describe "Sign up button" do
      before { click_link(signup) }

      it { should have_title('Sign up') }
    end
  end
end
