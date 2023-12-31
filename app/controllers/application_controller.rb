class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!,unless: :admin_check, only: [:edit]
  
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
  
  def admin_check
    admin_signed_in?
  end
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end
end
