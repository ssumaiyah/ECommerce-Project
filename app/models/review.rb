class Review < ApplicationRecord
  belongs_to :user
  belongs_to :product

  validates :rating, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }
  validates :comment, presence: true

  def self.ransackable_attributes(auth_object = nil)
    ["id", "product_id", "user_id", "rating", "comment", "created_at", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["user", "product"]
  end
end
