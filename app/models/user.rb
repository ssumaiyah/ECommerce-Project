class User < ApplicationRecord
  # Include default devise modules. Others available are:
  #  :lockable, :timeoutable, :trackable and :omniauthable
  #   
  before_save :encrypt_password
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :orders
  has_many :reviews


  attr_accessor :password

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "email", "id", "password_digest", "updated_at"]
  end


  private
  
  def encrypt_password
    self.encrypted_password = Devise::Encryptor.digest(self.class, password) if password.present?
  end
  validates :email, presence: true, uniqueness: true
 validates :password, presence: true, length: { minimum: 6 }
validates :password_confirmation, presence: true
end
