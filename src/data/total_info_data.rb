class TotalInfoData
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
