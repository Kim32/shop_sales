require_relative 'data/shop_data'
require_relative 'data/total_info_data'
require_relative 'module/read_file'
require_relative 'module/display'
require_relative 'module/calc'

class Utility
  include ReadFile
  include Display
  include Calc

  #名前のリストを取得するメソッド
  def get_shop_name_list(shop_datas)
    shop_name_list = []
    shop_name_list[0] = shop_datas[0].shop_name
    name_list_count = 1

    shop_datas.each do |shop_data|
      shop_name_list.each do |shop_name|
        if(shop_name == shop_data.shop_name)
          break
        end
        if(shop_name == shop_name_list[shop_name_list.size - 1])
          shop_name_list[name_list_count] = shop_data.shop_name
          name_list_count += 1
        end
      end
    end
    return shop_name_list
  end
end

utility = Utility.new

#コマンドライン引数の確認
if(ARGV.empty?)
  puts "引数にCSVファイルのパスを入力してください。"
  exit(1)
elsif(ARGV[0] =~ /^(?!.*\.csv$)/)
  puts "引数にCSVファイルのパスを入力してください。"
  exit(1)
end

#CSVファイルの読み込み
begin
  shop_infos = utility.read_file(ARGV[0])
rescue SystemCallError => e
  puts "class=[#{e.class}] message=[#{e.message}]"
  exit(1)
rescue IOError => e
  puts "class=[#{e.class}] message=[#{e.message}]"
  exit(1)
end

#項目とショップ情報が存在するか確認
if(shop_infos.size < 2)
  puts "項目またはショップ情報が存在しません。"
  exit(1)
end

#項目の取得
item = shop_infos[0]
shop_infos.slice!(0)

#明細情報の取得
shop_datas = []
shop_infos.each do |str|
  shop_info = str.chomp.split(",")
  shop_datas.push(ShopData.new(shop_info[0], shop_info[1],shop_info[2],shop_info[3]))
end

#集計情報の取得
shop_name_list = utility.get_shop_name_list(shop_datas)
total_info_datas = utility.calc_total_info(shop_name_list, shop_datas)

#明細情報の表示
utility.display_specification_info(item.chomp, shop_datas)

#集計情報の表示
utility.display_total_info(total_info_datas)
