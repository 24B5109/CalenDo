class RemoveDefaultFromBlogsStartTime < ActiveRecord::Migration[7.1]
  def change
    change_column_default :blogs, :start_time, nil
  end
end
