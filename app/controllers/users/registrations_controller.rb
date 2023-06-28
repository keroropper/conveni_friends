class Users::RegistrationsController < Devise::RegistrationsController
  def new
    if user_signed_in?
      redirect_to root_path
    else
      build_resource
      yield resource if block_given?
      respond_with resource
      @email = params[:email] if params[:email].present?
    end
  end

  def create
    build_resource(sign_up_params)

    resource.save
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  protected

  def after_inactive_sign_up_path_for(resource)
    users_confirmation_info_path(email: resource.email)
  end
end
