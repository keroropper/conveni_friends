class UsersController < ApplicationController
  def dummy
    redirect_to new_user_registration_path
  end
end
