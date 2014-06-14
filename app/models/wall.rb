class Wall < ActiveRecord::Base
  has_many :participants, dependent: :delete_all
  has_many :users, through: :participants
  has_many :posts, through: :participants

  validates :name, presence: true, length: { maximum: 50 }

  def participate(user)
    self.participants.build(user_id: user.id)
  end

  def participate?(user)
    self.users.include? user
  end

  def participant(user)
    self.participants.find_by(user_id: user.id)
  end
end
