class Friend < ActiveRecord::Base
  belongs_to :user
  belongs_to :target_user, class_name: 'User',
                           foreign_key: 'target_user_id'

  validates :user_id       , presence: true,
                             uniqueness: { scope: :target_user_id }
  validates :target_user_id, presence: true
end
