class Category < ApplicationRecord
  has_many :product_categories
  has_many :products, through: :product_categories

  

  validates :name, presence: true
  def self.ransackable_attributes(auth_object = nil)
    ["id", "name", "created_at","updated_at"]
  end
  def self.ransackable_associations(auth_object = nil)
    ["products"]
  end
end
