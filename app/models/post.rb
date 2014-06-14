class Post < ActiveRecord::Base
  belongs_to :participant

  validates :participant_id, presence: true
  validates :content       , presence: true

  def user; self.participant.user end
  def wall; self.participant.wall end
end
