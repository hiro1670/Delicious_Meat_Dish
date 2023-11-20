class RecipeComment < ApplicationRecord
  #アソシエーション
  belongs_to :user
  belongs_to :recipe
  
  #星が1~5までで保存できるようになっています
  validates :star, numericality: {
    less_than_or_equal_to: 5,
    greater_than_or_equal_to: 1}, presence: true
    
  validates :comment, presence: true
end
