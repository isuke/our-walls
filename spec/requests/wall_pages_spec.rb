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

end
