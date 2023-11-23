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
    elsif params[:sorted_by_read_count]
      #@recipes = Recipe.includes(:read_counts).order('read_counts.id DESC').page(params[:page])
      recipes = Recipe.sorted_by_read_count
      @recipes = Kaminari.paginate_array(recipes).page(params[:page])
    else
      @recipes = Recipe.all.page(params[:page])
    end
    
    # @recipes = Recipe.all
  end
  
  def show
    @recipe = Recipe.find(params[:id])
    @recipe_comment = RecipeComment.new
    if user_signed_in?
      unless ReadCount.where(created_at: Time.zone.now.all_day).find_by(user_id: current_user.id, recipe_id: @recipe.id)
        current_user.read_counts.create(recipe_id: @recipe.id)
      end
    end
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
    flash[:notice] = "レシピを削除しました"
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
    flash[:notice] = "自分が投稿したレシピ以外の編集画面には遷移できません"
    redirect_to recipes_path unless @recipe
  end
end
