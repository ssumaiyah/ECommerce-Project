# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require 'faker'


# Known password for all users
user_password = 'password123'

# Create regular users
50.times do
  User.create!(
    email: Faker::Internet.email,
    password_digest: BCrypt::Password.create(user_password),
    created_at: Faker::Time.between(from: 2.years.ago, to: Date.today),
    updated_at: Faker::Time.between(from: 2.years.ago, to: Date.today)
  )
end

# Create artisans
80.times do
  Artisan.create!(
    name: Faker::Name.name,
    bio: Faker::Lorem.paragraph,
    contact_email: Faker::Internet.email,
    created_at: Faker::Time.between(from: 2.years.ago, to: Date.today),
    updated_at: Faker::Time.between(from: 2.years.ago, to: Date.today)
  )
end

# Create categories
50.times do
  Category.create!(
    name: Faker::Commerce.department,
    created_at: Faker::Time.between(from: 2.years.ago, to: Date.today),
    updated_at: Faker::Time.between(from: 2.years.ago, to: Date.today)
  )
end

# Create products and associate them with artisans and categories
200.times do
  product = Product.create!(
    name: Faker::Commerce.product_name,
    description: Faker::Lorem.paragraph,
    price: Faker::Commerce.price(range: 10.0..100.0),
    quantity_available: Faker::Number.between(from: 1, to: 100),
    artisan_id: Artisan.pluck(:id).sample,
    created_at: Faker::Time.between(from: 2.years.ago, to: Date.today),
    updated_at: Faker::Time.between(from: 2.years.ago, to: Date.today)
  )

  # Associate each product with 1-3 random categories
  Category.order("RANDOM()").limit(rand(1..3)).each do |category|
    ProductCategory.create!(
      product: product,
      category: category,
      created_at: Faker::Time.between(from: 2.years.ago, to: Date.today),
      updated_at: Faker::Time.between(from: 2.years.ago, to: Date.today)
    )
  end
end

# Create orders and order items
20.times do
  order = Order.create!(
    user_id: User.pluck(:id).sample,
    total_amount: Faker::Commerce.price(range: 50.0..500.0),
    order_date: Faker::Date.between(from: 1.year.ago, to: Date.today),
    status: ['Pending', 'Processing', 'Shipped', 'Delivered'].sample,
    created_at: Faker::Time.between(from: 1.year.ago, to: Date.today),
    updated_at: Faker::Time.between(from: 1.year.ago, to: Date.today)
  )

  # Each order can have 1-5 order items
  rand(1..5).times do
    OrderItem.create!(
      order: order,
      product_id: Product.pluck(:id).sample,
      quantity: Faker::Number.between(from: 1, to: 5),
      price_at_purchase: Faker::Commerce.price(range: 10.0..100.0),
      created_at: Faker::Time.between(from: 1.year.ago, to: Date.today),
      updated_at: Faker::Time.between(from: 1.year.ago, to: Date.today)
    )
  end
end

# Create reviews
100.times do
  Review.create!(
    product_id: Product.pluck(:id).sample,
    user_id: User.pluck(:id).sample,
    rating: Faker::Number.between(from: 1, to: 5),
    comment: Faker::Lorem.paragraph,
    created_at: Faker::Time.between(from: 1.year.ago, to: Date.today),
    updated_at: Faker::Time.between(from: 1.year.ago, to: Date.today)
  )
end
