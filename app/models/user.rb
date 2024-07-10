class User < ApplicationRecord
  has_many :orders
  has_many :reviews

  validates :email, presence: true, uniqueness: true
  validates :password_digest, presence: true
end
