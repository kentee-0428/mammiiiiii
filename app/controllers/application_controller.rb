class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  private
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :email, :encrypted_password, :name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :image, :gender, :introduction])
  end

  # ログイン/ログアウト後に遷移するpathを設定
  def after_sign_in_path_for(resource)
    users_path
  end

  def after_sign_out_path_for(resource)
    root_path
  end
end
