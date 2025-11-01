class Tag < ApplicationRecord
    validates :name, presence: true
    has_many :blog_tag_relations, dependent: :destroy
    has_many :blogs, through: :blog_tag_relations, dependent: :destroy
end
