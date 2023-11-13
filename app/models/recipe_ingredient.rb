class RecipeIngredient < ApplicationRecord
  belongs_to :recipe, foreign_key: [:date,:name]
  
  validates :name, presence: true
  validates :quantity, presence: true
end
