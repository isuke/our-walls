require 'spec_helper'

describe User do

  let(:user) do
    User.new(name: "Example User", email: "user@example.com",
             password: "foobar", password_confirmation: "foobar")
  end

  subject { user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:friends) }
  it { should respond_to(:friend_users) }
  it { should respond_to(:friend?) }
  it { should respond_to(:make_friend) }
  it { should respond_to(:unmake_friend) }
  it { should respond_to(:participants) }
  it { should respond_to(:walls) }

  it { should be_valid }

  context "when name is not present" do
    before { user.name = " " }
    it { should_not be_valid }
  end

  context "when name is too long" do
    before { user.name = "a" * 51 }
    it { should_not be_valid }
  end

    context "when name is already taken" do
      before do
        user_with_same_email = user.dup
        user_with_same_email.email = "other@example.com"
        user_with_same_email.save
      end

      it { should_not be_valid }
    end

  context "when email is not present" do
    before { user.email = " " }
    it { should_not be_valid }
  end

  context "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com user@foo..bar]
      addresses.each do |invalid_address|
        user.email = invalid_address
        expect(user).not_to be_valid
      end
    end
  end

  context "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        user.email = valid_address
        expect(user).to be_valid
      end
    end
  end

  context "when email address is already taken" do
    before do
      user_with_same_email = user.dup
      user_with_same_email.name = "other"
      user_with_same_email.email.upcase!
      user_with_same_email.save
    end

    it { should_not be_valid }
  end

  context "email address with mixed case" do
    let(:mixed_case_email) { "Foo@ExAMPle.CoM" }

    it "should be saved as all lower-case" do
      user.email = mixed_case_email
      user.save
      expect(user.reload.email).to eq mixed_case_email.downcase
    end
  end

  context "when password is not present" do
    let(:user) do
      user = User.new(name: "Example User", email: "user@example.com",
                       password: " ", password_confirmation: " ")
    end
    it { should_not be_valid }
  end

  context "when password doesn't match confirmation" do
    before { user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end

  context "when password is too short" do
    before { user.password = user.password_confirmation = "a" * 5 }
    it { should be_invalid }
  end

  describe "return value of authenticate method" do
    before { user.save }
    let(:found_user) { User.find_by(email: user.email) }

    context "with valid password" do
      let(:user_for_valid_password) { found_user.authenticate(user.password) }

      it { should eq user_for_valid_password }
    end

    context "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      it { should_not eq user_for_invalid_password }
      specify { expect(user_for_invalid_password).to be_false }
    end
  end

  describe "remember token" do
    before { user.save }
    its(:remember_token) { should_not be_blank }
  end

  describe "friend" do
    context "when have friends" do
      let(:other_user) { FactoryGirl.create(:user) }
      before do
        user.save
        user.make_friend other_user
      end

      its(:friend_users) { should include other_user }

      describe "#friend?" do
        it "should return true" do
          expect(user.friend?(other_user)).to be_true
        end
      end

      describe "#unmake_friend" do
        it "should decrement the Friend count" do
          expect do
            user.unmake_friend other_user
          end.to change(Friend, :count).by(-1)
        end
      end
    end

    context "when have not a friend" do
      let(:other_user) { FactoryGirl.create(:user) }
      describe "#friend?" do
        it "should return false" do
          expect(user.friend?(other_user)).to be_false
        end
      end
    end

  end
end
