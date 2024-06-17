require 'csv'

# Clear existing data to avoid duplication
puts "Clearing existing data..."
Product.destroy_all
Category.destroy_all

# Read data from CSV
csv_file = Rails.root.join('db/products.csv')
csv_data = File.read(csv_file)

# If CSV was created by Excel in Windows, you may need to set an encoding type:
# products = CSV.parse(csv_data, headers: true, encoding: 'iso-8859-1')
products = CSV.parse(csv_data, headers: true)

# Loop through each row in the CSV
products.each_with_index do |row, index|
  # Get the category name from the CSV row
  category_name = row['category']

  # Find or create the category
  category = Category.find_or_create_by(name: category_name)

  # Create the product
  Product.create(
    title: row['name'],
    description: row['description'],
    price: row['price'].to_f, # Convert price to float
    stock_quantity: row['stock quantity'].to_i, # Convert stock_quantity to integer
    category: category
  )

  # Log progress
  puts "Created product #{index + 1}/#{products.size}" if (index + 1) % 50 == 0
end

puts "Seeding completed successfully!"
