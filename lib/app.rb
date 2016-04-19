require 'date'
require 'json'
path = File.join(File.dirname(__FILE__), '../data/products.json')
file = File.read(path)
products_hash = JSON.parse(file)
@products = {}

# Print today's date
puts DateTime.now.strftime("%Y-%m-%d-%H:%M")


class Product
  #for now leaving public accessible
  @title
  @description
  @brand
  @stock
  @full_price
  @purchases

  attr_accessor :title,:description,:brand,:stock,:full_price,:purchases

  def get_num_purchases
    num = 0
    if @purchases.nil? || @purchases.length == 0
    else
      @purchases.each do |purchase|
        num += 1
      end
    end
    num
  end

  def get_total_sales
    amount = 0
    if @purchases.nil? || @purchases.length == 0
    else
      @purchases.each do |purchase|
        amount += purchase.price
      end
    end
    format(amount)
  end

  def get_avg_sale_price
    amount = 0
    if @purchases.nil? || @purchases.length == 0
    else
      @purchases.each do |purchase|
        amount += purchase.price
      end
      amount /= @purchases.length
    end
    format(amount)
  end

  def get_avg_dollar_discount
    avg_price = get_avg_sale_price
    avg_discount = full_price.to_f - avg_price.to_f
    format(avg_discount)
  end

  private

  def format(value)
    val = sprintf("%.2f", value)
    val
  end

end

class Purchase
  @channel
  @date
  @price
  @shipping
  @currency
  @user

  attr_accessor :channel,:date,:price,:shipping,:currency,:user
end

class User
  @name
  @state

  attr_accessor :name,:state
end

def create_products(hash)
  hash["items"].each do |item|
    product = Product.new
    product.title = item["title"]
    product.description = item["description"]
    product.brand = item["brand"]
    product.stock = item["stock"]
    product.full_price = item["full-price"]
    if item["purchases"] && item["purchases"].length > 0
      product.purchases = []
      item["purchases"].each do |purchase|
        purch = Purchase.new
        purch.channel = purchase["channel"]
        purch.date = purchase["date"]
        purch.price = purchase["price"]
        purch.shipping = purchase["shipping"]
        purch.currency = purchase["currency"]
        purch.user = User.new
        purch.user.name = purchase['user']['name']
        purch.user.state = purchase['user']['state']
        product.purchases << purch
      end
    end
    @products[product.title] = product
  end
end


puts "                     _            _       "
puts "                    | |          | |      "
puts " _ __  _ __ ___   __| |_   _  ___| |_ ___ "
puts "| '_ \\| '__/ _ \\ / _` | | | |/ __| __/ __|"
puts "| |_) | | | (_) | (_| | |_| | (__| |_\\__ \\"
puts "| .__/|_|  \\___/ \\__,_|\\__,_|\\___|\\__|___/"
puts "| |                                       "
puts "|_|                                       "

create_products(products_hash)

# For each product in the data set:
# Print the name of the toy
# Calculate and print the total number of purchases
# Calculate and print the total amount of sales
# Calculate and print the average price the toy sold for
# Calculate and print the average discount (% or $) based off the average sales price
# Print the retail price of the toy
@products.each_value do |product|
  puts ""
  puts "Name of Toy: " + product.title
  puts "Total Toy Purchases: " + product.get_num_purchases.to_s
  puts "Total Toy Sales: $" + product.get_total_sales
  puts "Avg Toy Sale Price: $" + product.get_avg_sale_price
  puts "Avg Toy discount: $" + product.get_avg_dollar_discount
  puts "Toy Retail Price: $" + product.full_price
end


	puts " _                         _     "
	puts "| |                       | |    "
	puts "| |__  _ __ __ _ _ __   __| |___ "
	puts "| '_ \\| '__/ _` | '_ \\ / _` / __|"
	puts "| |_) | | | (_| | | | | (_| \\__ \\"
	puts "|_.__/|_|  \\__,_|_| |_|\\__,_|___/"
	puts

# For each brand in the data set:
  # Print the name of the brand
  # Count and print the number of the brand's toys we stock
  # Calculate and print the average price of the brand's toys
  # Calculate and print the total revenue of all the brand's toy sales combined
