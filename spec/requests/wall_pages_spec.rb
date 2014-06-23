require 'spec_helper'

describe "Wall pages" do

  subject { page }

  describe "new" do
    let(:user) { FactoryGirl.create(:user) }

    context "when signed-in user" do
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

    context "when unsignd-in user" do
      before { visit new_wall_path user }
      it { should have_title('Our Walls') }
    end
  end

  describe "show" do
    let(:wall)          { FactoryGirl.create(:wall) }
    let(:user1)         { FactoryGirl.create(:user) }
    let(:user2)         { FactoryGirl.create(:user) }
    let!(:friend_user1) { FactoryGirl.create(:user) }
    let!(:friend_user2) { FactoryGirl.create(:user) }
    let!(:participant1) do
        FactoryGirl.create(:owner,
                           wall: wall,
                           user: user1)
    end
    let!(:participant2) do
      FactoryGirl.create(:participant,
                         wall: wall,
                         user: user2)
    end
    let!(:post1_1) do
      FactoryGirl.create(:post, participant: participant1)
    end
    let!(:post1_2) do
      FactoryGirl.create(:post, participant: participant2)
    end

    before do
      FactoryGirl.create(:friend,
                         user_id: user1.id,
                         target_user_id: friend_user1.id)
      FactoryGirl.create(:friend,
                         user_id: user1.id,
                         target_user_id: friend_user2.id)
    end

    context "when signed-in user" do

      context "When owner user" do
        before do
          sign_in user1
          visit wall_path(wall)
        end

        it { should have_title(wall.name) }
        it { should have_content("owner is You") }
        it { should have_content("Participating") }
        it { should have_selector("span", text: wall.users.count) }
        it { should have_button 'Leave' }
        it { should have_button 'Invite' }

        it "should list each users" do
          wall.users.each do |u|
            expect(page).to have_selector('li', text: u.name)
          end
        end

        it "shuld list each posts" do
          wall.posts do |p|
            expect(page).to have_content(p.name)
            expect(page).to have_content(p.context)
          end
        end

        context "when click post button" do

          context "with invalid context" do
            before { fill_in 'post_content', with: " " }
            it "should not add posts" do
              expect do
                click_button "Post"
              end.not_to change(Post, :count)
            end
          end

          context "with valid context" do
            before { fill_in 'post_content', with: "Lorem ipsum" }
            it "should add posts" do
              expect do
                click_button "Post"
              end.to change(Post, :count).by(1)
            end
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

      context "When not owner user" do
        before do
          sign_in user2
          visit wall_path(wall)
        end

        it { should have_title(wall.name) }
        it { should have_content("owner is #{user1.name}") }
        it { should have_content("Participating") }
        it { should have_selector("span", text: wall.users.count) }
        it { should_not have_button 'Leave' }
        it { should_not have_button 'Invite' }

        it "should list each users" do
          wall.users.each do |u|
            expect(page).to have_selector('li', text: u.name)
          end
        end

        it "shuld list each posts" do
          wall.posts do |p|
            expect(page).to have_content(p.name)
            expect(page).to have_content(p.context)
          end
        end

        context "when post" do
          before { fill_in 'post_content', with: "Lorem ipsum" }
          it "should add posts" do
            expect do
              click_button "Post"
            end.to change(Post, :count).by(1)
          end
        end

        it "shuld list each friend users" do
          user1.friend_users do |u|
            expect(page).to have_selector('li', text: u.name)
          end
        end
      end

    end

    context "when unsignd-in user" do
      before { visit wall_path(wall) }
      it { should have_title('Our Walls') }
    end
  end

end
