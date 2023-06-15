class ConfirmationsController < Devise::ConfirmationsController
  def new
    @email = params[:email]
    self.resource = resource_class.new
  end

  def info
    @email = params[:email]
  end

  private

  # 認証メール再送信後に遷移するパス
  def after_resending_confirmation_instructions_path_for(_resource_name)
    is_navigational_format? ? users_confirmation_info_path : '/'
  end

  # メールアドレス認証後に遷移するパス
  def after_confirmation_path_for(_resource_name, resource)
    sign_in(resource)
    '/' if is_navigational_format?
  end
end
