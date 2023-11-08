class Public::UsersController < ApplicationController
  
  def show
    @user = User.find(params[:id])
    @recipes = @user.recipes
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
end
