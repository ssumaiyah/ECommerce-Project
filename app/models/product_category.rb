class ProductCategory < ApplicationRecord
  belongs_to :product
  belongs_to :category

  def self.ransackable_attributes(auth_object = nil)
    ["id","product_id","category_id", "created_at","updated_at"]
  end
end
