class Artisan < ApplicationRecord
  has_many :products
  def self.ransackable_attributes(auth_object = nil)
    ["id", "name", "bio", "contact_email", "created_at","updated_at"]
  end
  def self.ransackable_associations(auth_object = nil)
    ["products"]
  end
  validates :name, presence: true
  validates :contact_email, presence: true
end
