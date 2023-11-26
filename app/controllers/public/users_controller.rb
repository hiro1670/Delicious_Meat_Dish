class Public::UsersController < ApplicationController
  before_action :is_matching_login_user, only: [:edit, :update]
  before_action :ensure_guest_user, only: [:edit]
  
  def show
    @user = User.find(params[:id])
    @recipes = @user.recipes.page(params[:page])
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = "登録情報を変更しました"
      redirect_to user_path(@user)
    else
      render :edit
    end
  end
  
  def favorites
    @user = User.find(params[:id])
    favorites = Favorite.where(user_id: @user.id).pluck(:recipe_id)
    @favorite_recipes = Recipe.where(id: favorites)
    @recipes = @favorite_recipes.page(params[:page])
  end
  
  def confirm
    @user = current_user
  end
  
  def withdraw
    @user = current_user
    # is_deletedカラムをtrueに変更することにより削除フラグを立てる
    @user.update(is_deleted: true)
    reset_session
    flash[:notice] = "退会処理を実行いたしました"
    redirect_to root_path
  end
  
  private
  
  def user_params
    params.require(:user).permit(:name, :email, :is_deleted)
  end
  
  #他人の登録情報編集画面にいかない
  def is_matching_login_user
    user = User.find(params[:id])
    unless admin_signed_in?
      if user.id != current_user.id
        flash[:notice] = "他のユーザーの編集画面には遷移できません"
        redirect_to recipes_path
      end
    end
  end
  
  #ゲストは編集画面にいけない
  def ensure_guest_user
    @user = User.find(params[:id])
    if @user.guest_user?
      redirect_to user_path(current_user), notice: "ゲストユーザーはプロフィール編集画面へ遷移できません。"
    end
  end
end
