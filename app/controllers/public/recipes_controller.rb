class Public::RecipesController < ApplicationController
  before_action :ensure_user, only: [:edit, :update, :destroy]
  
  def new
    @recipe = Recipe.new
  end
  
  def create
    @recipe = Recipe.new(recipe_params)
    @recipe.user_id = current_user.id
    if @recipe.save
      flash[:notice] = "レシピを投稿しました"
     redirect_to recipes_path
    else
      render :new
    end
  end
  
  def index
    if params[:latest]
      @recipes = Recipe.latest.page(params[:page])
    elsif params[:old]
      @recipes = Recipe.old.page(params[:page])
    elsif params[:star_count]
      @recipes = Recipe.includes(:recipe_comments).order('recipe_comments.star DESC').page(params[:page])
    elsif params[:favorites_count]
      @recipes = Recipe.includes(:favorites).order('favorites.id DESC').page(params[:page])
    else
      @recipes = Recipe.all.page(params[:page])
    end
    
    # @recipes = Recipe.all
  end
  
  def show
    @recipe = Recipe.find(params[:id])
    @recipe_comment = RecipeComment.new
  end
  
  def edit
    @recipe = Recipe.find(params[:id])
  end
  
  def update
    @recipe = Recipe.find(params[:id])
    if @recipe.update(recipe_params)
      flash[:notice] = "レシピ情報を変更しました"
      redirect_to recipe_path(@recipe.id)
    else
      render :edit
    end
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
      :tag,#タグ
      :recipe_image,#レシピ画像
      recipe_ingredients_attributes: [:id, :name, :quantity, :_destroy],
      procedures_attributes: [:id, :body, :_destroy]
      )
  end
  
  #他人の投稿編集ページにいかないようにする
  def ensure_user
    @recipes = current_user.recipes
    @recipe = @recipes.find_by(id: params[:id])
    redirect_to recipes_path unless @recipe
  end
end
