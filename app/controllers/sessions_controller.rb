class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: login_params[:email])

    if @user
      flash.now[:success] = "Log in successful"
      redirect_to home_url
    else
      flash.now[:warning] = "Invalid email or password"
      render :new
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end

  private

  def login_params 
    params.require(:session).permit(:email, :password)
  end
end
