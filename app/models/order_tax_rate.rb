class OrderTaxRate < ApplicationRecord
  belongs_to :order
  belongs_to :tax_rate
end
