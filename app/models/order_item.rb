class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  def self.ransackable_attributes(auth_object = nil)
    ["id", "order_id", "product_id", "price_at_purchase", "quantity", "created_at","updated_at"]
  end
  def self.ransackable_associations(auth_object = nil)
    ["order","product"]
  end

  validates :quantity, numericality: { greater_than: 0 }
  validates :price_at_purchase, numericality: { greater_than_or_equal_to: 0 }


end
