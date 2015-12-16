require 'csv'
require 'date'

class SalesManagemet
  attr_accessor :shops

  def initialize(csv_path)
    @shops = []
    reader = CSV.open(csv_path, 'r')
    reader.shift
    reader.each do |csv|
      shop = @shops.find { |v| v.name == csv[0] }
      if shop.nil?
        shop = Shop.new(name: csv[0])
        @shops << shop
      end
      shop.add_sales_detail(SalesDetail.new(sales_date: Date.parse(csv[1]), sales_money: csv[2], customer_count: csv[3]))
    end
  end

  def display_specification_info
    puts "明細情報:"
    puts "店舗名|売上日|売上金額|客数|客単価"
    @shops.each do |shop|
      shop.sales_details.each do |detail|
        print "#{detail.shop.name}|"
        print "#{detail.sales_date.strftime("%Y/%m/%d")}|"
        print "#{detail.sales_money.round(0)}|"
        print "#{detail.customer_count.round(0)}|"
        print "#{sprintf("%.2f", detail.customer_unit.round(2))}\n"
      end
    end
  end

  def display_total_info
    puts "集計情報:"
    puts "店舗名|売上金額の合計|売上金額の平均|客数の合計|客数の平均"
    @shops.each do |shop|
      print "#{shop.name}|"
      print "#{shop.sum_sales_money.round(0)}|"
      print "#{sprintf("%.2f", shop.avg_sales_money.round(2))}|"
      print "#{shop.sum_customer_count.round(0)}|"
      print "#{sprintf("%.2f", shop.avg_customer_count.round(2))}\n"
    end
  end
end

class SalesDetail
  attr_accessor :shop, :sales_date, :sales_money, :customer_count

  def initialize(sales_date: nil, sales_money: 0, customer_count: 0)
    @sales_date = sales_date
    @sales_money = sales_money.to_f
    @customer_count = customer_count.to_f
  end

  def customer_unit
    @sales_money / @customer_count
  end
end

class Shop
  attr_accessor :sales_details
  attr_accessor :name

  def initialize(name: nil)
    @name = name
    @sales_details = []
  end

  def add_sales_detail(sales_detail)
    sales_detail.shop = self
    @sales_details << sales_detail
  end

  def sum_sales_money
    @sales_details.inject(0) { |sum, v| sum += v.sales_money }
  end

  def avg_sales_money
    sum_sales_money / @sales_details.size
  end

  def sum_customer_count
    @sales_details.inject(0) { |sum, v| sum += v.customer_count }
  end

  def avg_customer_count
    sum_customer_count / @sales_details.size
  end
end

manager = SalesManagemet.new('sales.csv')
manager.display_specification_info
manager.display_total_info