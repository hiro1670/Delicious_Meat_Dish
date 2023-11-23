class Users::SessionsController < Devise::SessionsController
  def guest_sign_in
    user = User.guest
    sign_in user
    redirect_to root_path, notice: 'ゲストユーザーとしてログインしました。'
  end
  
  def guest_sign_out
    user = User.guest
    delete_guest_user_data(user)
    sign_out(user)
    redirect_to root_path
  end
  
  private
  
  def delete_guest_user_data(user)
    user.recipes.destroy_all
    user.recipe_comments.destroy_all
    user.read_counts.destroy_all
    #user.favorites.destroy_all
  end
end