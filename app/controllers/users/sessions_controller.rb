class Users::SessionsController < Devise::RegistrationsController
  def new
    if user_signed_in?
      redirect_to root_path
    else
      self.resource = resource_class.new(sign_in_params)
      clean_up_passwords(resource)
      yield resource if block_given?
      respond_with(resource, serialize_options(resource))
    end
  end
end
