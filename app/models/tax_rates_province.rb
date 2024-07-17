class TaxRatesProvince < ApplicationRecord
  belongs_to :tax_rate
  belongs_to :province
end
