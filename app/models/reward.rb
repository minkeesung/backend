class Reward < ApplicationRecord
  validates :project, :title, :description, :cost, presence: true

  belongs_to :project, inverse_of: :rewards
  has_many :pledges, as: :pledgeable

  def total_backers
    pledges.count
  end
end
