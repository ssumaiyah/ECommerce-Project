class Artisan < ApplicationRecord
  has_many :products

  validates :name, presence: true
  validates :bio, presence: true
  validates :contact_email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  def self.ransackable_attributes(auth_object = nil)
    ["id", "name", "bio", "contact_email", "created_at","updated_at"]
  end
  def self.ransackable_associations(auth_object = nil)
    ["products"]
  end
  
end
