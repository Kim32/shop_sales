module Display
  #明細情報を表示するメソッド
  def display_specification_info(item, shop_datas)
    puts "明細情報:"
    puts "#{item.gsub(/,/, '|')}|客単価"
    shop_datas.each do |shop_data|
      print "#{shop_data.shop_name}|"
      print "#{shop_data.sales_data}|"
      print "#{shop_data.sales_amount}|"
      print "#{shop_data.customers}|"
      puts "#{shop_data.ave_spending_per_customer}"
    end
  end

  #集計情報を表示するメソッド
  def display_total_info(total_info_datas)
    puts
    puts "集計情報:"
    puts "店舗名|売上金額の合計|売上金額の平均|客数の合計|客数の平均"
    total_info_datas.each do |total_info_data|
      print "#{total_info_data.shop_name}|"
      print "#{total_info_data.sum_sales_amount}|"
      print "#{total_info_data.ave_sales_amount}|"
      print "#{total_info_data.sum_customers}|"
      puts "#{total_info_data.ave_customers}"
    end
  end
end
