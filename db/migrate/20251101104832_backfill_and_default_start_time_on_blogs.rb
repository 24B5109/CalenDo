class BackfillAndDefaultStartTimeOnBlogs < ActiveRecord::Migration[7.1]
  # モデルを直参照しないための軽量クラス
  class MBlog < ApplicationRecord
    self.table_name = "blogs"
  end

  def up
    # NULL を現在時刻で補正
    MBlog.where(start_time: nil).update_all(start_time: Time.current)

    # 1900年より前など異常値があれば現在時刻で補正（必要十分）
    MBlog.where("start_time < ?", Time.new(1900,1,1)).update_all(start_time: Time.current)

    # 以後の新規レコードのデフォルトを現在時刻に
    change_column_default :blogs, :start_time, -> { "CURRENT_TIMESTAMP" }
  end

  def down
    change_column_default :blogs, :start_time, nil
  end
end