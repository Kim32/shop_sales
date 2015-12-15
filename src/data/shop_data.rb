class ShopData
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
end
