class TaxRate < ApplicationRecord
  has_many :order_tax_rates
  has_many :orders, through: :order_tax_rates

  has_many :tax_rates_provinces
  has_many :provinces, through: :tax_rates_provinces

  # validates :name, presence: true
  validates :rate, numericality: { greater_than_or_equal_to: 0 }
  validates :tax_type, presence: true
end
