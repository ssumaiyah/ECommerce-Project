class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :orders
  has_many :reviews

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "email", "id", "password_digest", "updated_at"]
  end

  validates :email, presence: true, uniqueness: true
  validates :password_digest, presence: true
end
