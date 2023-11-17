class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  def after_sign_in_path_for(resource)
    flash[:notice] = "ログインしました"
    root_path
  end
  
  def after_sign_up_path_for(resource)
    flash[:notice] = "ユーザー登録をしました"
    user_path(current_user.id)
  end
  
  def after_sign_out_path_for(resource)
    flash[:notice] = "ログアウトしました"
    root_path
  end
  
  protected
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end
end
