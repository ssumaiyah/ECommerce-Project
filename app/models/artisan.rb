class Artisan < ApplicationRecord
  has_many :products

  validates :name, presence: true
  validates :contact_email, presence: true
end
