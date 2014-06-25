require 'spec_helper'

describe Wall do

  let(:wall) { FactoryGirl.create(:wall) }

  subject { wall }

  it { should respond_to(:name) }
  it { should respond_to(:participants) }
  it { should respond_to(:participant) }
  it { should respond_to(:users) }
  it { should respond_to(:participate) }
  it { should respond_to(:participant) }
  it { should respond_to(:participant?) }
  it { should respond_to(:posts) }
  it { should respond_to(:owner_user) }
  it { should respond_to(:owner_user?) }

  it { should be_valid }

  context "when name is not present" do
    before { wall.name = " " }
    it { should_not be_valid }
  end

  context "when name is too long" do
    before { wall.name = "a" * 51 }
    it { should_not be_valid }
  end

  context "when name is already taken" do
    before { wall.dup.save }

    it { should be_valid }
  end

  describe "participate" do
    let(:user) { FactoryGirl.create(:user) }

    context "when participate user" do
      before { wall.participate(user).save! }

        it "should be true" do
          expect(wall.participant?(user)).to be_true
        end

      context "when owner user" do
        before { wall.participant(user).update_attributes!(owner: true) }

        it "should be true" do
          expect(wall.owner_user?(user)).to be_true
        end

        its(:owner_user) { should eq user }
      end

      context "when not owner user" do
        it "should be false" do
          expect(wall.owner_user?(user)).to be_false
        end
      end
    end

    context "when no participate user" do
      it "should be false" do
        expect(wall.participant?(user)).to be_false
      end
    end

  end

end
