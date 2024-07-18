# app/models/order.rb

class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy

  scope :in_progress, -> { where(status: 'in_progress') }

  def add_product(product_id, quantity)
    order_item = order_items.find_by(product_id: product_id)

    if order_item
      order_item.update(quantity: order_item.quantity + quantity)
    else
      product = Product.find(product_id)
      order_item = order_items.create(product: product, quantity: quantity)
    end
  end
  def self.ransackable_associations(auth_object = nil)
    ["order_items", "user"]
  end
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "id_value", "order_date", "status", "subtotal", "total_amount", "updated_at", "user_id"]
  end
end
