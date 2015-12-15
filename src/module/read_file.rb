module ReadFile
  # ファイルを読み込むメソッド
  def read_file(file_path)
    shop_infos = []
    File.open(file_path) do |file|
      file.each do |line|
        shop_infos.push(line)
      end
    end
    return shop_infos
  end
end
