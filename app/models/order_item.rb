# app/models/order_item.rb
class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :quantity, numericality: { only_integer: true, greater_than: 0 }

  def total_price
    product.price * quantity
  end


  def self.ransackable_attributes(auth_object = nil)
    ["id", "order_id", "product_id", "price_at_purchase", "quantity", "created_at", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["order", "product"]
  end
end
