class Public::RecipeCommentsController < ApplicationController
  
  def create
    recipe = Recipe.find(params[:recipe_id])
    comment = current_user.recipe_comments.new(recipe_comment_params)
    comment.recipe_id = recipe.id
    comment.user_id = current_user.id
    if comment.save
      flash[:notice] = "コメント/レビューしました"
      redirect_to recipe_path(recipe)
    else
      render :show
    end
  end
  
  def destroy
    RecipeComment.find(params[:id]).destroy
    flash[:notice] = "コメント/レビューを削除しました"
    redirect_to request.referer
  end
  
  private
  
  def recipe_comment_params
    params.require(:recipe_comment).permit(:comment, :star)
  end
end
