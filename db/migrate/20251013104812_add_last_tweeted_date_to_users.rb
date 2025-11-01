class AddLastTweetedDateToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :last_tweeted_date, :date
  end
end
