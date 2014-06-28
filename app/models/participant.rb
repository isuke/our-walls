class Participant < ActiveRecord::Base
  belongs_to :wall
  belongs_to :user
  has_many :posts, dependent: :destroy

  validates :wall_id, presence: true,
                      uniqueness: { scope: :user_id }
  validates :user_id, presence: true
end
