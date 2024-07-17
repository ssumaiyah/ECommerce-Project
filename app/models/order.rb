class Order < ApplicationRecord
 
  belongs_to :user
  has_many :order_items
  has_many :products, through: :order_items
  def self.ransackable_attributes(auth_object = nil)
    ["id", "user_id", "total_amount", "order_date","status", "created_at","updated_at"]
  end
  def self.ransackable_associations(auth_object = nil)
    ["user","order_items"]
  end
  before_save :calculate_totals, if: :will_save_change_to_subtotal?

  def add_product(product_id, quantity)
  current_item = order_items.find_by(product_id: product_id)
  if current_item
    current_item.increment(:quantity, quantity)
  else
    current_item = order_items.build(product_id: product_id, quantity: quantity)
  end
  current_item.save
end

  def calculate_totals
    self.subtotal = order_items.sum(&:total_price)
    self.total_amount = subtotal + calculate_taxes
  end

  def calculate_taxes
    province = user.province
    tax_rates = province.tax_rates
    taxes = 0
    tax_rates.each do |tax_rate|
      taxes += subtotal * tax_rate.rate
      order_tax_rates.build(tax_rate: tax_rate)
    end
    taxes
  end

  validates :total_amount, numericality: { greater_than_or_equal_to: 0 }
  validates :order_date, presence: true
  validates :status, inclusion: { in: ['Pending', 'Processing', 'Shipped', 'Delivered'] }
end
