class Public::RecipesController < ApplicationController
  
  def new
    @recipe = Recipe.new
    @recipe_ingredients = @recipe.recipe_ingredients.build#親モデル.子モデル.buildで子モデルのインスタンス作成
  end
  
  def create
    @recipe = Recipe.new(recipe_params)
    @recipe.user_id = current_user.id
    @recipe.save
    redirect_to recipes_path
  end
  
  def index
    @recipes = Recipe.all
  end
  
  def show
    @recipe = Recipe.find(params[:id])
    @recipe_ingredients = @recipe.recipe_ingredients.build
  end
  
  def edit
    @recipe = Recipe.find(params[:id])
  end
  
  def update
    @recipe = Recipe.find(params[:id])
    @recipe.update(recipe_params)
    redirect_to recipe_path(@recipe.id)
  end
  
  def destroy
    @recipe = Recipe.find(params[:id])
    @recipe.destroy
    redirect_to recipes_path
  end
  
  private
  
  def recipe_params#accepts_nested_attributes_forで指定したrecipe_ingredientsモデルをrecipe_ingredients_attributes: []として一緒に追加して送ることができる。
    params.require(:recipe).permit(
      :user_id,
      :name,#レシピ名
      :explanation,#説明
      :process,#手順
      :tag,#タグ
      :recipe_image,#レシピ画像
      recipe_ingredients_attributes: [:name, :quantity, :_destroy],
      procedures_attributes: [:body, :process_image, :_destroy]
      )
  end
end
