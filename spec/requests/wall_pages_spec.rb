require 'spec_helper'

describe "Wall pages" do

  subject { page }

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

    before do
      FactoryGirl.create(:post, participant: participant1)
      FactoryGirl.create(:post, participant: participant2)

      FactoryGirl.create(:friend,
                         user_id: user1.id,
                         target_user_id: friend_user1.id)
      FactoryGirl.create(:friend,
                         user_id: user1.id,
                         target_user_id: friend_user2.id)
      30.times do
        FactoryGirl.create(:post, participant: participant1)
      end
    end

    context "when signed-in user" do

      context "when owner user" do
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
          wall.users.where('user_id <> ?', user1.id).each do |u|
            expect(page).to have_selector('td', text: u.name)
          end
        end

        describe "pagination" do
          it { should have_selector('div.pagination') }
          it "should list each post" do
            wall.posts.paginate(page: 1).each do |p|
              expect(page).to have_selector('li div p', text: p.content)
            end
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

      context "when not owner user" do
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
