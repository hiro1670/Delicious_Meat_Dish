class Recipe < ApplicationRecord
  belongs_to :customer
  
  has_many :recipe_ingredients, dependent: :destroy
  has_many :procedures, dependent: :destroy
  
  #関連付けしたモデルを一緒にデータ保存できるようにする
  accepts_nested_attributes_for :procedures, allow_destroy: true
  accepts_nested_attributes_for :recipe_ingredients, allow_destroy: true
  
  has_one_attached :recipe_image
  
  def get_recipe_image(width, height)
    unless recipe_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      recipe_image.attach(io: File.open(file_path), filename: 'no_image.jpg', content_type: 'image/jpg')
    end
    recipe_image.variant(resize_to_limit: [width, height]).processed
  end
end