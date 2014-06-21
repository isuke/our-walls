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

        it { should have_title('Our Walls') }
        it { should have_link('Sign out') }
        it { should have_selector('div.alert.alert-success', text: 'Welcome') }
      end
    end
  end

  describe "user info page" do
    let(:delete_user) { 'delete account' }
    let(:delete_wall) { 'delete' }
    let(:user) { FactoryGirl.create(:user) }
    let(:other_user) { FactoryGirl.create(:user) }
    let(:wall1) { FactoryGirl.create(:wall) }
    let(:wall2) { FactoryGirl.create(:wall) }

    before do
      #TODO: refactoring
      p1 = wall1.participate(user)
      p1.owner = true
      p1.save
      wall1.participate(other_user).save

      wall2.participate(user).save
      p2 = wall2.participate(other_user)
      p2.owner = true
      p2.save
      end

    context "when signd-in user" do

      before { sign_in user }

      context "visit this user info page" do

        before { visit user_path(user) }

        it { should have_title(user.name) }
        it { should have_content(user.name) }
        it { should have_content(user.email) }
        it { should have_link(delete_user, href: user_path(user)) }
        it { should have_content("Walls") }
        it { should have_selector("span", text: user.walls.count) }
        it { should have_link(wall1.name) }
        it { should have_link(wall2.name) }
        it { should     have_content("You") }
        it { should     have_content(wall2.owner.name) }
        it { should     have_link(delete_wall, href: wall_path(wall1)) }
        it { should_not have_link(delete_wall, href: wall_path(wall2)) }

        context "when click the delete link" do

          it "should be able to delete the user" do
            expect do
              click_link(delete_user)
            end.to change(User, :count).by(-1)
          end

          context "after delete the user" do
            before { click_link(delete_user) }

            it {should have_title('Our Walls')}
          end
        end

        context "when click the create wall link" do
          before { click_link 'create wall' }

          it { should have_title('Create Wall') }
        end

        context "when click a delete wall link" do
          it "should be able to delete the wall" do
            expect do
              click_link(delete_wall, href: wall_path(wall1))
            end.to change(Wall, :count).by(-1)
          end
          it "should be able to delete participate" do
            expect do
              click_link(delete_wall, href: wall_path(wall1))
            end.to change(Participant, :count).by(-wall1.users.count)
          end
        end

        context "When click a wall link" do
          before { click_link wall1.name }

          it { should have_title(wall1.name) }
        end

        # TODO: friends spec
      end

      context "visit other user info page" do
        let(:other_user) { FactoryGirl.create(:user) }

        before { visit user_path(other_user) }

        it { should have_title('Our Walls') }
        it { should have_selector('div.alert.alert-danger',
                                  text: 'Please sign in with the corrent user.') }
      end
    end

    context "when unsignd-in user" do
      before { visit users_path }
      it { should have_title('Our Walls') }
    end
  end

  describe "index" do
    let(:user) { FactoryGirl.create(:user) }

    before(:all) { 10.times { FactoryGirl.create(:user) } }
    after(:all)  { User.delete_all }

    context "when signed-in user" do

      before do
        sign_in user
        visit users_path
      end

      it { should have_title('Users')}
      it "should list each users" do
        User.where(['id <> ?', user.id]).each do |u|
          expect(page).to have_selector('div', text: u.name)
        end
      end
    end

    context "when unsignd-in user" do
      before { visit user_path(user) }
      it { should have_title('Our Walls') }
    end

  end
end
