class Page < ApplicationRecord
  validates :title, presence: true, length: { maximum: 255 }
  validates :content, presence: true

  def self.ransackable_attributes(auth_object = nil)
    ["content", "created_at", "id", "title", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end
end
