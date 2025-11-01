class AddRemindDateToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :remind_date, :date
  end
end
