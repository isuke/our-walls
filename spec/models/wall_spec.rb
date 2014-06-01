require 'spec_helper'

describe Wall do

  let(:wall) { FactoryGirl.create(:wall) }

  subject { wall }

  it { should respond_to(:name) }
  it { should respond_to(:participants) }
  it { should respond_to(:users) }
  it { should respond_to(:participate) }
  it { should respond_to(:participate?) }

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

  describe "participate?" do
    let(:user) { FactoryGirl.create(:user) }

    context "when participate user" do
      before { wall.participate(user).save! }

        it "should be true" do
          expect(wall.participate?(user)).to be_true
        end
    end

    context "when no participate user" do
      it "should be false" do
        expect(wall.participate?(user)).to be_false
      end
    end
  end

end
