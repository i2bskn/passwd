class ProfilesController < ApplicationController
  # GET /profile
  def show; end

  # GET /profile/edit
  def edit; end

  # PATCH /profile
  def update
    if current_user.update(user_param)
      redirect_to profile_path
    else
      render action: :edit
    end
  end

  # PATCH /profile/update_password
  def update_password
    current_user.update_password(params[:old_password], params[:new_password])
    redirect_to profile_path
  end

  private
    def user_param
      params.require(:user).permit(:name, :email)
    end
end

