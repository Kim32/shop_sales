require 'csv'

class SalesManagment
  attr_reader :shop_infos

  # ファイルを読み込む
  def initialize(file_path)
    @shop_infos = []
    CSV.foreach(file_path) do |record|
        @shop_infos.push(record)
    end
    return @shop_infos
  end

  #明細情報を表示するメソッド
  def self.display_specification_info(header, shop_records)
    puts "明細情報:"
    puts "#{header.to_csv.chomp.gsub(/,/, '|')}|客単価"
    shop_records.each do |shop_data|
      print "#{shop_data.shop_name}|"
      print "#{shop_data.sales_data}|"
      print "#{shop_data.sales_amount}|"
      print "#{shop_data.customers}|"
      puts "#{shop_data.ave_spending_per_customer}"
    end
  end

  #集計情報を表示するメソッド
  def self.display_total_info(total_info_records)
    puts
    puts "集計情報:"
    puts "店舗名|売上金額の合計|売上金額の平均|客数の合計|客数の平均"
    total_info_records.each do |total_info_data|
      print "#{total_info_data.shop_name}|"
      print "#{total_info_data.sum_sales_amount}|"
      print "#{total_info_data.ave_sales_amount}|"
      print "#{total_info_data.sum_customers}|"
      puts "#{total_info_data.ave_customers}"
    end
  end
end

class SalesDetail
  @shop_name_list = []

  attr_accessor :shop_name,
    :sales_data,
    :sales_amount,
    :customers,
    :ave_spending_per_customer

  def initialize(shop_name, sales_data, sales_amount, customers)
    @shop_name = shop_name
    @sales_data = sales_data
    @sales_amount = sales_amount
    @customers = customers
    @ave_spending_per_customer = sprintf("%.2f",
      (sales_amount.to_f / customers.to_f).round(2))
  end

  #名前のリストを取得するメソッド
  def self.get_shop_name_list(shop_records)
    @shop_name_list[0] = shop_records[0].shop_name
    name_list_count = 1

    shop_records.each do |shop_data|
      @shop_name_list.each do |shop_name|
        if(shop_name == shop_data.shop_name)
          break
        end
        if(shop_name == @shop_name_list[@shop_name_list.size - 1])
          @shop_name_list[name_list_count] = shop_data.shop_name
          name_list_count += 1
        end
      end
    end
  end

  #集計情報を計算するメソッド
  def self.calc_total_info(shop_records)
    total_info_records = []

    @shop_name_list.each do |shop_name|
      sum_sales_amount = 0
      sum_customers = 0
      total_sales_data = 0

      shop_records.each do |shop_data|
        if(shop_name == shop_data.shop_name)
          sum_sales_amount += shop_data.sales_amount.to_i
          sum_customers += shop_data.customers.to_i
          total_sales_data += 1
        end
      end

      total_info_records.push(Shop.new(
        shop_name,
        sum_sales_amount,
        sprintf("%.2f",sum_sales_amount / total_sales_data.round(2)),
        sum_customers,
        sprintf("%.2f",sum_customers / total_sales_data.round(2))
      ))
    end
    return total_info_records
  end
end

class Shop
  attr_accessor :shop_name,
    :sum_sales_amount,
    :ave_sales_amount,
    :sum_customers,
    :ave_customers

  def initialize(
      shop_name,
      sum_sales_amount,
      ave_sales_amount,
      sum_customers,
      ave_customers
    )
    @shop_name = shop_name
    @sum_sales_amount = sum_sales_amount
    @ave_sales_amount = ave_sales_amount
    @sum_customers = sum_customers
    @ave_customers = ave_customers
  end
end

begin
  #コマンドライン引数の確認
  if(ARGV.empty?)
    raise "引数にCSVファイルのパスを入力してください。"
  elsif(ARGV[0] =~ /^(?!.*\.csv$)/)
    raise "引数にCSVファイルのパスを入力してください。"
  end

  sales_management = SalesManagment.new(ARGV[0])

  #ヘッダーとショップ情報が存在するか確認
  # TODO: SalesManagmentのinitializeの中で行うのが望ましい
  if(sales_management.shop_infos.size < 2)
    raise "項目またはショップ情報が存在しません。"
  end

  #ヘッダーの取得
  header = sales_management.shop_infos[0]
  sales_management.shop_infos.slice!(0)

  sales_details = []
  sales_management.shop_infos.each do |shop_info|
    sales_details.push(SalesDetail.new(shop_info[0], shop_info[1], shop_info[2], shop_info[3]))
  end

  #ネームリストの作成
  SalesDetail.get_shop_name_list(sales_details)

  #集計情報の取得
  total_info_records = SalesDetail.calc_total_info(sales_details)

  #明細情報の表示
  SalesManagment.display_specification_info(header, sales_details)

  #集計情報の表示
  SalesManagment.display_total_info(total_info_records)

rescue SystemCallError, IOError => e
  puts SystemCallError.new("class=[#{e.class}] message=[#{e.message}]")
rescue => e
  puts e.message
end
