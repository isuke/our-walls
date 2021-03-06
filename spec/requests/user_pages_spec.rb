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

  describe "show" do
    let(:delete_user)  { 'delete account' }
    let(:delete_wall)  { 'Delete' }
    let(:leave)        { 'Leave' }
    let(:create_wall)  { 'Create new wall' }

    let(:user)         { FactoryGirl.create(:user) }
    let(:other_user)   { FactoryGirl.create(:user) }
    let(:wall1)        { FactoryGirl.create(:wall) }
    let(:wall2)        { FactoryGirl.create(:wall) }
    let!(:p_w1_user) do
      FactoryGirl.create(:owner,
                         wall_id: wall1.id,
                         user_id: user.id)
    end
    let!(:p_w1_other_user) do
      FactoryGirl.create(:participant,
                         wall_id: wall1.id,
                         user_id: other_user.id)
    end
    let!(:p_w2_user) do
      FactoryGirl.create(:participant,
                         wall_id: wall2.id,
                         user_id: user.id)
    end
    let!(:p_w2_other_user) do
      FactoryGirl.create(:owner,
                         wall_id: wall2.id,
                         user_id: other_user.id)
    end

    before do
      FactoryGirl.create(:friend,
                         user_id: user.id,
                         target_user_id: other_user.id)

      3.times do
        FactoryGirl.create(:post,
                           participant_id: p_w1_user.id)
      end
    end

    context "when signd-in user" do

      before { sign_in user }

      context "visit the user's page" do

        before { visit user_path(user) }

        # user info
        it { should     have_title(user.name) }
        it { should     have_content(user.name) }
        it { should     have_content(user.email) }
        it { should     have_link(delete_user, href: user_path(user)) }

        # Walls
        it { should     have_content("Walls") }
        it { should     have_selector("span", text: user.walls.count) }
        it { should     have_content("You") }
        it { should     have_content(wall2.owner_user.name) }
        it { should     have_link(delete_wall, href: wall_path(wall1)) }
        it { should_not have_link(delete_wall, href: wall_path(wall2)) }
        it { should     have_button(leave    , count: 1) }
        it { should     have_button(create_wall) }

        # Friends
        it { should     have_content("Friends") }
        it { should     have_selector("span", text: user.friend_users.count) }

        it "should list each walls" do
          user.walls.each do |w|
            expect(page).to have_link(w.name)
          end
        end

        it "should list each friends" do
          user.friend_users do |u|
            expect(page).to have_content(u.name)
          end
        end

        context "when click the delete link" do

          it "should be able to delete the user" do
            expect do
              click_link(delete_user)
            end.to change(User, :count).by(-1)
          end

          it "should delete the user own walls" do
            expect do
              click_link(delete_user)
            end.to change(Wall, :count).by(-1)
          end

          context "after delete the user" do
            before { click_link(delete_user) }

            it {should have_title('Our Walls')}
          end
        end

        context "when click the create new wall button" do

          context "with invalid information" do
            it "should not create a wall" do
              expect { click_button create_wall }.not_to change(Wall, :count)
            end

            context "after submission" do
              before { click_button create_wall }

              it { should have_selector('div.alert.alert-danger', text: 'error') }
            end
          end

          context "with valid information" do
            before { fill_in "Wall Name", with: "Example Wall" }

            it "should create a wall" do
              expect { click_button create_wall }.to change(Wall, :count).by(1)
            end

            it "should create a participant" do
              expect { click_button create_wall }.to change(Participant, :count).by(1)
            end

            context "after save the wall" do
              before { click_button create_wall }

              it { should have_title(user.name) }
              it { should have_selector('div.alert.alert-success', text: 'Example Wall') }
            end
          end
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
          it "should be able to delete posts" do
            expect do
              click_link(delete_wall, href: wall_path(wall1))
            end.to change(Post, :count).by(-3)
          end
        end

        context "when click leave button" do
          it "should decrement participant" do
            expect do
              click_button leave, match: :first
            end.to change(Participant, :count).by(-1)
          end
        end

        context "When click a wall link" do
          before { click_link wall1.name }

          it { should have_title(wall1.name) }
        end
      end

      context "visit other user's page" do
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
    let(:user) { FactoryGirl.create(:user, name: "xxx") }

    before do
      FactoryGirl.create(:user, name: "abc")
      FactoryGirl.create(:user, name: "bcd")
      FactoryGirl.create(:user, name: "cdf")
    end

    context "when signed-in user" do

      before do
        sign_in user
        visit users_path
      end

      it { should have_title('Users')}

      describe "pagination" do
        before(:all) { 50.times { FactoryGirl.create(:user) } }
        after(:all)  { User.delete_all }

        it { should have_selector('div.pagination') }

        it "should list each user" do
          User.where('id <> ?', user.id).order('name').
               paginate(page: 1).each do |u|
            expect(page).to have_selector('li div', text: u.name)
          end
        end
      end

      describe "search" do
        before do
          fill_in "search", with: "bc"
          click_button "Search"
        end

        it "should not list each non hit user" do
          User.where("name like not '%bc%'").each do |u|
            expect(page).not_to have_selector('li div', text: u.name)
          end
        end
      end
    end

    context "when unsignd-in user" do
      before { visit user_path(user) }
      it { should have_title('Our Walls') }
    end

  end
end
