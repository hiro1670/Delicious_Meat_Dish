class RecipeIngredient < ApplicationRecord
  #アソシエーション
  belongs_to :recipe
  
  #バリデーション
  validates :name, presence: true
  validates :quantity, presence: true
end
