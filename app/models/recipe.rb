class Recipe < ApplicationRecord
  #アソシエーション
  belongs_to :user

  has_many :recipe_ingredients, dependent: :destroy
  has_many :procedures, dependent: :destroy
  has_many :recipe_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :read_counts, dependent: :destroy
  has_many :viewed_users, through: :read_counts, source: :user
  
  has_one_attached :recipe_image

  #バリデーション
  validates :name, presence: true
  validates :explanation, presence: true
  validates :tag, presence: true
  validates :recipe_image, presence: true

  #関連付けしたモデルを一緒にデータ保存できるようにする
  accepts_nested_attributes_for :procedures, allow_destroy: true
  accepts_nested_attributes_for :recipe_ingredients, allow_destroy: true

  #並び替え機能
  scope :latest, -> {order(created_at: :desc)}
  scope :old, -> {order(created_at: :asc)}
  scope :sorted_by_recipe_comment, -> {joins(:recipe_comment).order('recipe_comments.star DESC')}
  scope :sorted_by_favorite, -> {joins(:favorite).order('favorites.id DESC')}
  #scope :sorted_by_read_count, -> {joins(:read_count).order('read_counts.id DESC')}
  scope :sorted_by_read_count, -> {includes(:viewed_users)
  .sort_by {|x| x.viewed_users.includes(:read_counts).size }. reverse }
  
  @recipes = Recipe.sorted_by_read_count

  #レシピ画像
  def get_recipe_image(width, height)
    unless recipe_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      recipe_image.attach(io: File.open(file_path), filename: 'no_image.jpg', content_type: 'image/jpg')
    end
    recipe_image.variant(resize_to_limit: [width, height]).processed
  end

  #いいね機能
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end
  
  #検索機能
  def self.search(word)
    #joinメソッドは複数のテーブルを１つに結合したいときに使う
    Recipe.joins(:recipe_ingredients).where(
      "recipes.name LIKE? OR recipes.explanation LIKE? OR recipes.tag LIKE? OR recipe_ingredients.name LIKE?",
      "%#{word}%", "%#{word}%", "%#{word}%", "%#{word}%").uniq
  end
end