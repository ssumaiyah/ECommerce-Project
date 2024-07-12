require 'faker'

# Clear existing data
Review.destroy_all
OrderItem.destroy_all
Order.destroy_all
Artisan.destroy_all
User.destroy_all
ProductCategory.destroy_all
Product.destroy_all
Category.destroy_all

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

# Create categories in batches
categories_count = 50
batch_size = 10

(0..categories_count).step(batch_size) do |offset|
  Category.insert_all(
    (offset...offset + batch_size).map do
      {
        name: Faker::Commerce.department(max: 1),
        created_at: Faker::Time.between(from: 2.years.ago, to: Date.today),
        updated_at: Faker::Time.between(from: 2.years.ago, to: Date.today)
      }
    end
  )
end
# Create products and associate them with artisans and categories
200.times do
  product = Product.create!(
    name: Faker::Commerce.product_name,
    description: Faker::Lorem.paragraph(sentence_count: 3, supplemental: true, random_sentences_to_add: 4),
    price: Faker::Commerce.price(range: 10.0..100.0),
    quantity_available: Faker::Number.between(from: 1, to: 100),
    artisan_id: Artisan.pluck(:id).sample,
    created_at: Faker::Time.between(from: 2.years.ago, to: Date.today),
    updated_at: Faker::Time.between(from: 2.years.ago, to: Date.today)
  )

  # Associate each product with 1-3 random categories
  Category.order(Arel.sql('RANDOM()')).limit(rand(1..3)).each do |category|
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
      quantity: Faker::Number.between(from: 1, to: 20),
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

AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?
