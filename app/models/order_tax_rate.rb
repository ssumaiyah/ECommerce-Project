class OrderTaxRate < ApplicationRecord
  belongs_to :order
  belongs_to :tax_rate

  # Validations
  # validates :order_id, presence: true
  #validates :tax_rate_id, presence: true
 # validates :order_id, uniqueness: { scope: :tax_rate_id, message: "should have a unique combination with tax rate" }

  def self.ransackable_attributes(auth_object = nil)
    ["id", "order_id", "tax_rate_id", "created_at", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["order", "tax_rate"]
  end
end
