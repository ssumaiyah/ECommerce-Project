class User < ApplicationRecord
 # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :province, optional: true
  has_many :orders, dependent: :destroy
  has_many :reviews
  

  #validates :address, presence: true, on: :update
  #validates :province_id, presence: true, on: :update
  #validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  #validates :password, presence: true, on: :create

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "email", "id", "password_digest", "updated_at","encrypted_password","name"]
  end
  def self.ransackable_associations(auth_object = nil)
    ['orders', 'province', 'reviews']
  end


end
