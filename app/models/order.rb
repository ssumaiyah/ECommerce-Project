class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items
  def self.ransackable_attributes(auth_object = nil)
    ["id", "user_id", "total_amount", "order_date","status", "created_at","updated_at"]
  end
  def self.ransackable_associations(auth_object = nil)
    ["user","order_items"]
  end
  
  validates :total_amount, numericality: { greater_than_or_equal_to: 0 }
  validates :order_date, presence: true
  validates :status, inclusion: { in: ['Pending', 'Processing', 'Shipped', 'Delivered'] }
end
