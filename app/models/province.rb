class Province < ApplicationRecord
  has_many :tax_rates_provinces
  has_many :tax_rates, through: :tax_rates_provinces

  has_many :users
  validates :name, presence: true

  # Add other associations as needed
end
