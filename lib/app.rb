require 'date'
require 'json'
path = File.join(File.dirname(__FILE__), '../data/products.json')
file = File.read(path)
products_hash = JSON.parse(file)

# Print today's date
puts DateTime.now.strftime("%Y-%m-%d-%H:%M")

module ToyMoney
  def format(value)
    val = sprintf("%.2f", value)
    val
  end
end

class ProductReport
  #for now leaving public accessible
  @title
  @description
  @brand
  @stock
  @full_price
  @purchases

  attr_accessor :title,:description,:brand,:stock,:full_price,:purchases

  include(ToyMoney)

  def do_prod_report
    puts ""
    puts "Name of Toy: " + @title
    puts "Toy Retail Price: $" + @full_price
    puts "Total Toy Purchases: " + get_num_purchases.to_s
    puts "Total Toy Sales: $" + get_total_sales
    puts "Avg Toy Sale Price: $" + get_avg_sale_price
    puts "Avg Toy discount: $" + get_avg_dollar_discount
  end

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

class BrandReport
  include(ToyMoney)

  def initialize(prod_reports)
    @brands = {}
    prod_reports.each_value do |prod_report|
      brand = prod_report.brand.to_sym
      if @brands.has_key?(brand)
        #don't add key twice but do add this products
        #information that we need
        toy_name = prod_report.title.delete(" ").to_sym
        avg_price = prod_report.get_avg_sale_price.to_f
        toy_revenue = prod_report.get_total_sales.to_f
        toy_info = {
            :avg_toy_price => avg_price,
            :toy_tot_revenue => toy_revenue
        }
        if @brands[brand].has_key?(toy_name)
          puts "This toy name already exists, overwrite as update"
          @brands[brand][toy_name] = toy_info
        else
          @brands[brand][toy_name] = {}
          @brands[brand][toy_name] = toy_info
        end

      else
        toy_name = prod_report.title.delete(" ").to_sym
        avg_price = prod_report.get_avg_sale_price.to_f
        toy_revenue = prod_report.get_total_sales.to_f

        toy_info = {
          toy_name => {
              :avg_toy_price => avg_price,
              :toy_tot_revenue => toy_revenue
          }
        }
        @brands[brand] = toy_info
      end
    end
  end

  def do_brand_report
    @brands.each do |brand,toy_data|
      puts ""
      puts "Brand: " + brand.to_s
      puts "Number Toys: " + get_num_toys(brand).to_s
      puts "Avg Toy Price: $" + get_avg_toy_price(brand)
      puts "Total Toy Sales: $" + get_total_toy_sales(brand)
    end
  end

  private

  def get_num_toys(brand)
    num_toys = @brands[brand].length
  end

  def get_avg_toy_price(brand)
    avg_amount = 0.0
    @brands[brand].each_value do |data|
      avg_amount += data[:avg_toy_price]
    end
    avg = avg_amount / @brands[brand].length
    format(avg)
  end

  def get_total_toy_sales(brand)
    tot_sales = 0.0
    @brands[brand].each_value do |data|
      tot_sales += data[:toy_tot_revenue]
    end
    format(tot_sales)
  end

end


def create_products(hash)
  prod_reports = {}
  hash["items"].each do |item|
    report = ProductReport.new
    report.title = item["title"]
    report.description = item["description"]
    report.brand = item["brand"]
    report.stock = item["stock"]
    report.full_price = item["full-price"]
    if item["purchases"] && item["purchases"].length > 0
      report.purchases = []
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
        report.purchases << purch
      end
    end
    prod_reports[report.title] = report
  end
  prod_reports
end


puts "                     _            _       "
puts "                    | |          | |      "
puts " _ __  _ __ ___   __| |_   _  ___| |_ ___ "
puts "| '_ \\| '__/ _ \\ / _` | | | |/ __| __/ __|"
puts "| |_) | | | (_) | (_| | |_| | (__| |_\\__ \\"
puts "| .__/|_|  \\___/ \\__,_|\\__,_|\\___|\\__|___/"
puts "| |                                       "
puts "|_|                                       "

# For each product in the data set:
# Print the name of the toy
# Calculate and print the total number of purchases
# Calculate and print the total amount of sales
# Calculate and print the average price the toy sold for
# Calculate and print the average discount (% or $) based off the average sales price
# Print the retail price of the toy
prod_reports = create_products(products_hash)
prod_reports.each_value do |prodreport|
  prodreport.do_prod_report
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
brand_report = BrandReport.new(prod_reports)
brand_report.do_brand_report


