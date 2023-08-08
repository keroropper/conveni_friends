class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :current_user_notification
  before_action :incomplete_tasks

  def self.render_with_signed_in_user(user, *args)
    ActionController::Renderer::RACK_KEY_TRANSLATION['warden'] ||= 'warden'
    proxy = Warden::Proxy.new({}, Warden::Manager.new({})).tap { |i| i.set_user(user, scope: :user) }
    renderer = self.renderer.new('warden' => proxy)
    renderer.render(*args)
  end

  private

  def current_user_notification
    if current_user
      @notifications = current_user.notifications.includes(:sender).page(params[:page]).per(20)
      @count = current_user.notifications.where(read: false).count
    end
  end

  def incomplete_tasks
    @evaluatee_users = current_user.incomplete_evaluation_users.with_attached_profile_photo.page(params[:page]).per(20) if current_user
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit :sign_up, keys: [:name, :age, :gender, :email, :password, :password_confirmation]
    devise_parameter_sanitizer.permit :sign_in, keys: [:email, :password]
  end
end
