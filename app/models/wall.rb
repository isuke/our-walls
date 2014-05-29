class Wall < ActiveRecord::Base
  has_many :participants, dependent: :delete_all
  has_many :users, through: :participants

  validates :name, presence: true, length: { maximum: 50 }
end
