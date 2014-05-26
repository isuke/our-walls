require 'spec_helper'

describe "Static pages" do

  subject { page }

  describe "Home page" do
    before { visit root_path }

    let(:signup) { 'Sign up now!' }
    let(:signin) { 'Sign in' }

    it { should     have_title('Our Walls') }
    it { should_not have_title('| Home') }
    it { should have_link(signup)}
    it { should have_link(signin)}

    describe "Sign up button" do
      before { click_link(signup) }

      it { should have_title('Sign up')}
    end
  end
end
