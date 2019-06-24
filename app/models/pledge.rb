class Pledge < ApplicationRecord
  validates :amount, :pledgeable_id, :pledgeable_type, :backer_id, presence: true
  validates_numericality_of :amount, greater_than: 0

  belongs_to :pledgeable, polymorphic: true
  belongs_to :backer,
    class_name: :User,
    primary_key: :id,
    foreign_key: :backer_id
end
