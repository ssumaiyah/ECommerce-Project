class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items

  validates :total_amount, numericality: { greater_than_or_equal_to: 0 }
  validates :order_date, presence: true
  validates :status, inclusion: { in: ['Pending', 'Processing', 'Shipped', 'Delivered'] }
end
