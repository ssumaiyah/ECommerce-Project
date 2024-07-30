class Province < ApplicationRecord
  has_many :tax_rates_provinces
  has_many :tax_rates, through: :tax_rates_provinces

  has_many :users
  #validates :name, presence: true, uniqueness: true


  has_many :orders

  def calculate_taxes(subtotal)
    pst = self.pst_rate || 0
    gst = self.gst_rate || 0
    hst = self.hst_rate || 0
    pst_amount = subtotal * pst / 100
    gst_amount = subtotal * gst / 100
    hst_amount = subtotal * hst / 100
    pst_amount + gst_amount + hst_amount
  end


end
