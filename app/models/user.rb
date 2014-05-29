class User < ActiveRecord::Base
  has_many :friends          , dependent: :delete_all
  has_many :friends_as_target, dependent: :delete_all,
                               class_name: 'Friend',
                               foreign_key: 'target_user_id'
  has_many :participants     , dependent: :delete_all
  has_many :walls, through: :participants

  validates :name, presence: true,
            length: { maximum: 50 },
            uniqueness: true
  validates :email, presence: true,
            format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i },
            uniqueness: true
  validates :password, length: { minimum: 6 }

  has_secure_password

  before_save { email.downcase! }
  before_create :create_remember_token

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def friend?(other_user)
    self.friends.find_by(target_user_id: other_user.id)
  end

  def make_friend(other_user)
    self.friends.create!(target_user_id: other_user.id)
  end

  def unmake_friend(other_user)
    self.friends.find_by(target_user_id: other_user.id).destroy
  end

  private

    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end
end
