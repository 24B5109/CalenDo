class Blog < ApplicationRecord
    belongs_to :user
     has_one_attached :image
     has_many :blog_tag_relations, dependent: :destroy
     has_many :tags, through: :blog_tag_relations, dependent: :destroy
    after_create :renzoku_hantei

    private
    def renzoku_hantei
    puts "始まったよー！！"
    user = self.user
    today = user.remind_date
    toukoubi = created_at.to_date
    last_date = user.last_tweeted_date
    return if last_date == today

    puts "同日投稿判定を潜り抜けたよ！"
        if last_date == today - 1
        new_kaisuu = user.kaisuu.to_i + 1
        puts "回数が増えたよ！"
        else
        puts "1回目だよ！"
        new_kaisuu = 1
        end
        user.update!(
    kaisuu: new_kaisuu,
    last_tweeted_date: today
    )
end
end
