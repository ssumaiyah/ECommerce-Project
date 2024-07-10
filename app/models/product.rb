class Product < ApplicationRecord
  belongs_to :artisan
  has_many :order_items
  has_many :product_categories
  has_many :categories, through: :product_categories
  has_many :reviews

  validates :name, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :quantity_available, numericality: { greater_than_or_equal_to: 0 }
end
