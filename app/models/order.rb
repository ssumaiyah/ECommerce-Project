class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_many :order_tax_rates
  has_many :tax_rates, through: :order_tax_rates
  belongs_to :province, optional: true

  before_save :calculate_totals

  validates :user, presence: true
  validates :subtotal, numericality: { greater_than_or_equal_to: 0 }, presence: true
  # validates :total_amount, numericality: { greater_than_or_equal_to: 0 }, presence: true
  # validates :order_date, presence: true
  # validates :address, presence: true

  scope :in_progress, -> { where(status: "in_progress") }

  def calculate_totals
    self.subtotal = order_items.sum { |item| item.price_at_purchase * item.quantity }
    taxes = calculate_taxes
    self.total_amount = subtotal + taxes.values.sum
  end

  def calculate_taxes
    taxes = {
      pst: tax_rate_value("PST"),
      gst: tax_rate_value("GST"),
      hst: tax_rate_value("HST"),
      qst: tax_rate_value("QST")
    }
    taxes.each { |key, value| taxes[key] = (value * subtotal / 100).to_f }
    taxes
  end

  def tax_rate_value(tax_type)
    tax_rates.find_by(tax_type: tax_type)&.rate.to_f || 0
  end

  def add_product(product_id, quantity)
    order_item = order_items.find_by(product_id:)

    if order_item
      order_item.update(quantity: order_item.quantity + quantity)
    else
      product = Product.find(product_id)
      order_items.create(product:, quantity:, price_at_purchase: product.price)
    end
  end

  def self.ransackable_associations(_auth_object = nil)
    ["order_items", "user", "province"]
  end

  def self.ransackable_attributes(_auth_object = nil)
    ["created_at", "id", "id_value", "order_date", "status", "subtotal", "total_amount",
     "updated_at", "user_id", "province_id"]
  end
end
