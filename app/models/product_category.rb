class ProductCategory < ApplicationRecord
  belongs_to :product
  belongs_to :category

  def self.ransackable_attributes(_auth_object = nil)
    ["id", "product_id", "category_id", "created_at", "updated_at"]
  end

  def self.ransackable_associations(_auth_object = nil)
    ["category", "product"]
  end
end
