class ApplicationController < ActionController::Base
  before_action :normalize_datetime_params

  private
  def normalize_datetime_params
    # ここに入れるキーは実際に使っているものを追加/削除してOK
    %i[date start_date start_time from to tweeted_date remind_date].each do |k|
      next unless params.key?(k)

      v = params[k]
      # "0" や空は削除（クエリに流さない）
      if v.blank? || v == '0'
        params.delete(k)
        next
      end

      # 文字列なら安全にTimeへ
      if v.is_a?(String)
        begin
          params[k] = Time.zone.parse(v)
        rescue ArgumentError, TypeError
          params.delete(k) # 解析できない値は捨てる
        end
      end
    end
  end
end











Yusuke Kobayashi_東京メンター へのメッセージ:入力中アイコン:Web62期




