module Calc
  #集計情報を計算するメソッド
  def calc_total_info(shop_name_list, shop_datas)
    total_info_datas = []
    shop_name_list.each do |shop_name|
      sum_sales_amount = 0
      sum_customers = 0
      total_sales_data = 0

      shop_datas.each do |shop_data|
        if(shop_name == shop_data.shop_name)
          sum_sales_amount += shop_data.sales_amount.to_i
          sum_customers += shop_data.customers.to_i
          total_sales_data += 1
        end
      end

      total_info_datas.push(TotalInfoData.new(
        shop_name,
        sum_sales_amount,
        sprintf("%.2f",sum_sales_amount / total_sales_data.round(2)),
        sum_customers,
        sprintf("%.2f",sum_customers / total_sales_data.round(2))
      ))
    end

    return total_info_datas
  end
end
