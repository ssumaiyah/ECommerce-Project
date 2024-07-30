class Product < ApplicationRecord

  belongs_to :artisan
  has_many :order_items
  has_many :product_categories
  has_many :categories, through: :product_categories
  has_many :reviews
  has_one_attached :image

  def self.ransackable_attributes(auth_object = nil)
    ["id", "name", "description", "price", "quantity_available", "artisan_id", "created_at","updated_at"]
  end

  scope :new_products, -> { where('created_at >= ?', 3.days.ago) }
  scope :recently_updated, -> { where('updated_at >= ? AND created_at < ?', 3.days.ago, 3.days.ago) }
  
  #validates :name, presence: true
  #validates :description, presence: true
  #validates :price, numericality: { greater_than_or_equal_to: 0 }
  #validates :quantity_available, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def self.ransackable_associations(auth_object = nil)
    ["artisan","order_items","product_categories","categories","reviews"]
  end

end

