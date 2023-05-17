# frozen_string_literal: true
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

def clear_db_and_files
  Category.destroy_all
  CategoryProduct.destroy_all
  Product.destroy_all
  Record.destroy_all
  User.destroy_all
  FileUtils.rm_rf(Rails.root.join('storage'))
end

clear_db_and_files

# ----------------------------------------------------- USERS
3.times do |i|
  User.create(email: "admin#{i + 1}@admin.com", 
              address: Faker::Address.full_address, 
              password: '123456',
              level: 'admin')
  User.create(email: "client#{i + 1}@client.com",
              address: Faker::Address.full_address,
              password: '123456')
end

admin_users = User.where(level: 'admin').map(&:id)
client_users = User.where(level: 'client').map(&:id)

# ----------------------------------------------------- CATEGORIES
5.times do |i|
  Record.create(recordable: Category.create(name: "categoria#{i + 1}"),
                action: 'creación de categoría por seed', user_id: admin_users.sample)
end

category_ids = Category.all.map(&:id)

# ----------------------------------------------------- PRODUCTS
24.times do
  user = admin_users.sample
  Record.create(recordable: Product.create(active: true,
                                           name: Faker::Commerce.product_name,
                                           price: Faker::Commerce.price(range: 1..99.99),
                                           stock: 99,
                                           user_id: user,
                                           category_ids: category_ids.sample(3)),
                action: 'creación de producto por seed', user_id: user)
end

products = Product.all
products.each_with_index do |product, index|
  product.pictures.attach(io: File.open("#{Rails.public_path}/images/#{index + 1}.png"), filename: "#{index + 1}.png")
  Record.create(recordable: product, action: 'agregado imagen por seed', user_id: product.user_id)
  3.times do
    number = rand(1..24)
    product.pictures.attach(io: File.open("#{Rails.public_path}/images/#{number}.png"), filename: "#{number}.png")
    Record.create(recordable: product, action: 'agregado imagen por seed', user_id: product.user_id)
  end
end
