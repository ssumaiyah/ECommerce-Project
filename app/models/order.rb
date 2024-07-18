class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_many :tax_rates, through: :order_tax_rates
  has_many :products, through: :order_items

  before_save :calculate_totals, if: :will_save_change_to_subtotal?

  scope :in_progress, -> { where(status: 'in_progress') }

  def add_product(product_id, quantity)
    product = Product.find(product_id)
    order_item = order_items.find_by(product_id: product.id)

    if order_item
      order_item.update(quantity: order_item.quantity + quantity)
    else
      order_items.create(product_id: product.id, quantity: quantity, price_at_purchase: product.price)
    end
    calculate_totals
    save
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

  validates :subtotal, numericality: { greater_than_or_equal_to: 0 }
  validates :total_amount, numericality: { greater_than_or_equal_to: 0 }
  validates :order_date, presence: true
  validates :status, inclusion: { in: ['in_progress', 'pending', 'paid', 'shipped', 'completed', 'cancelled'] }

  def self.ransackable_attributes(auth_object = nil)
    ["id", "user_id", "total_amount", "order_date", "subtotal", "status", "created_at", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["user", "order_items"]
  end
end
