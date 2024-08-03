class Province < ApplicationRecord
  has_many :tax_rates_provinces
  has_many :tax_rates, through: :tax_rates_provinces
  has_many :orders
  has_many :users

  validates :name, presence: true, uniqueness: true

  def calculate_taxes(subtotal)
    pst = pst_rate || 0
    gst = gst_rate || 0
    hst = hst_rate || 0
    pst_amount = subtotal * pst / 100
    gst_amount = subtotal * gst / 100
    hst_amount = subtotal * hst / 100
    pst_amount + gst_amount + hst_amount
  end
end
