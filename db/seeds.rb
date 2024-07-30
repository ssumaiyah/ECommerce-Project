require 'faker'
require 'bcrypt'

# Clear existing data
Review.destroy_all
OrderItem.destroy_all
Order.destroy_all
Artisan.destroy_all
User.destroy_all
ProductCategory.destroy_all
Product.destroy_all
Category.destroy_all
OrderTaxRate.delete_all
TaxRatesProvince.delete_all
TaxRate.delete_all
Province.delete_all

# List of provinces and their tax rates
provinces_with_tax_rates = [
  { name: 'Alberta', gst: 5, pst: 0, hst: 0 },
  { name: 'British Columbia', gst: 5, pst: 7, hst: 0 },
  { name: 'Manitoba', gst: 5, pst: 7, hst: 0 },
  { name: 'New Brunswick', gst: 0, pst: 0, hst: 15 },
  { name: 'Newfoundland and Labrador', gst: 0, pst: 0, hst: 15 },
  { name: 'Northwest Territories', gst: 5, pst: 0, hst: 0 },
  { name: 'Nova Scotia', gst: 0, pst: 0, hst: 15 },
  { name: 'Nunavut', gst: 5, pst: 0, hst: 0 },
  { name: 'Ontario', gst: 0, pst: 0, hst: 13 },
  { name: 'Prince Edward Island', gst: 0, pst: 0, hst: 15 },
  { name: 'Quebec', gst: 5, pst: 9.975, hst: 0 },
  { name: 'Saskatchewan', gst: 5, pst: 6, hst: 0 },
  { name: 'Yukon', gst: 5, pst: 0, hst: 0 }
]

# Seed Provinces table
provinces_with_tax_rates.each do |province|
  Province.create!(
    name: province[:name],
    created_at: Faker::Time.between(from: 2.years.ago, to: Date.today),
    updated_at: Faker::Time.between(from: 2.years.ago, to: Date.today)
  )
end

# Seed TaxRates table
provinces_with_tax_rates.each do |province|
  TaxRate.create!(
    name: "#{province[:name]} GST",
    rate: province[:gst],
    tax_type: 'GST',
    created_at: Faker::Time.between(from: 2.years.ago, to: Date.today),
    updated_at: Faker::Time.between(from: 2.years.ago, to: Date.today)
  )
  TaxRate.create!(
    name: "#{province[:name]} PST",
    rate: province[:pst],
    tax_type: 'PST',
    created_at: Faker::Time.between(from: 2.years.ago, to: Date.today),
    updated_at: Faker::Time.between(from: 2.years.ago, to: Date.today)
  ) if province[:pst] > 0
  TaxRate.create!(
    name: "#{province[:name]} HST",
    rate: province[:hst],
    tax_type: 'HST',
    created_at: Faker::Time.between(from: 2.years.ago, to: Date.today),
    updated_at: Faker::Time.between(from: 2.years.ago, to: Date.today)
  ) if province[:hst] > 0
end

# Seed users table
50.times do
  password = 'password123'
  User.create!(
    name: Faker::Name.name,
    email: Faker::Internet.email,
    password: password,
    password_confirmation: password,
    created_at: Faker::Time.between(from: 2.years.ago, to: Date.today),
    updated_at: Faker::Time.between(from: 2.years.ago, to: Date.today),
    province_id: Province.pluck(:id).sample
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

# Seed Orders table
100.times do
  order = Order.create!(
    user: User.order('RANDOM()').first,
    subtotal: Faker::Commerce.price(range: 50.0..100.0),
    total_amount: Faker::Commerce.price(range: 50.0..100.0),
    order_date: Faker::Date.between(from: 1.year.ago, to: Date.today),
    status: ['pending', 'paid', 'shipped', 'completed', 'cancelled' ].sample,
    created_at: Faker::Time.between(from: 1.year.ago, to: Date.today),
    updated_at: Faker::Time.between(from: 1.year.ago, to: Date.today)
  )

  rand(1..5).times do
    OrderItem.create!(
      order: order,
      product: Product.order('RANDOM()').first,
      quantity: rand(1..10),
      price_at_purchase: Faker::Commerce.price(range: 10.0..100.0),
      created_at: Faker::Time.between(from: 1.year.ago, to: Date.today),
      updated_at: Faker::Time.between(from: 1.year.ago, to: Date.today)
    )
  end
end

# Seed OrderTaxRates table
10.times do
  OrderTaxRate.create!(
    order_id: Order.pluck(:id).sample,  # Assign a random order_id
    tax_rate_id: TaxRate.pluck(:id).sample  # Assign a random tax_rate_id
  )
end

# Seed TaxRatesProvinces table
10.times do
  TaxRatesProvince.create!(
    tax_rate_id: TaxRate.pluck(:id).sample,    # Assign a random tax_rate_id
    province_id: Province.pluck(:id).sample     # Assign a random province_id
  )
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
