class SessionsController < ApplicationController
  # If you has been enabled `require_signin` in ApplicationController
  skip_before_action :require_signin

  # GET /signin
  def new; end

  # POST /signin
  def create
    # Returns nil or user
    @user = User.authenticate(params[:email], params[:password])

    if @user
      # Save user_id to session
      signin!(@user)
      redirect_to root_url
    else # Authentication fails
      render action: :new
    end
  end

  # DELETE /signout
  def destroy
    # Clear session (Only user_id)
    signout!
    redirect_to signin_url
  end
end

