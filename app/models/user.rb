class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :province
  has_many :orders
  has_many :reviews

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, on: :create

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "email", "id", "password_digest", "updated_at","encrypted_password","name"]
  end
  def self.ransackable_associations(auth_object = nil)
    ['orders', 'province', 'reviews']
  end


end
