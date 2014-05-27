class User < ActiveRecord::Base
  has_many :friends          , dependent: :delete_all
  has_many :friends_as_target, dependent: :delete_all,
                               class_name: 'Friend',
                               foreign_key: 'target_user_id'

  validates :name, presence: true, length: { maximum: 50 }
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

  private

    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end
end
