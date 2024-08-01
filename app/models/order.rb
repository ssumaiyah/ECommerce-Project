class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy
  belongs_to :province, optional: true
  has_many :order_tax_rates
  has_many :tax_rates, through: :order_tax_rates

  before_save :calculate_totals

  # Validations can be uncommented if needed
  # validates :user, presence: true
  # validates :status, presence: true, inclusion: { in: %w[in_progress completed cancelled], message: "%{value} is not a valid status" }
  # validates :subtotal, numericality: { greater_than_or_equal_to: 0 }, presence: true
  # validates :total_amount, numericality: { greater_than_or_equal_to: 0 }, presence: true
  # validates :order_date, presence: true
  # validates :address, presence: true

  scope :in_progress, -> { where(status: 'in_progress') }

 
  
    def calculate_totals
      gst_rate = tax_rates.find_by(tax_type: 'GST')&.rate.to_f || 0
      pst_rate = tax_rates.find_by(tax_type: 'PST')&.rate.to_f || 0
      hst_rate = tax_rates.find_by(tax_type: 'HST')&.rate.to_f || 0
      qst_rate = tax_rates.find_by(tax_type: 'QST')&.rate.to_f || 0
  
      subtotal = order_items.sum { |item| item.price_at_purchase * item.quantity }
      gst_amount = (gst_rate * subtotal / 100).to_f
      pst_amount = (pst_rate * subtotal / 100).to_f
      hst_amount = (hst_rate * subtotal / 100).to_f
      qst_amount = (qst_rate * subtotal / 100).to_f
      total_amount = subtotal + gst_amount + pst_amount + hst_amount + qst_amount
  
      self.subtotal = subtotal
      self.total_amount = total_amount
    end

  
  



  def add_product(product_id, quantity)
    order_item = order_items.find_by(product_id: product_id)
  
    if order_item
      order_item.update(quantity: order_item.quantity + quantity)
    else
      product = Product.find(product_id)
      order_items.create(product: product, quantity: quantity, price_at_purchase: product.price)
    end
  end
  

  def self.ransackable_associations(auth_object = nil)
    ["order_items", "user", "province"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "id_value", "order_date", "status", "subtotal", "total_amount", "updated_at", "user_id", "province_id"]
  end
end
