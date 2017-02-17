class SessionsController < ApplicationController

  skip_before_action :authenticate_user!, only: [:new, :create]
  before_action :forward_logged_in!, except: [:destroy]

  def new
    @form = LoginForm.new
  end

  def create
    @form = LoginForm.new(login_params)
    return form_errors unless @form.valid?

    @user = User.find_by(email: @form.email)

    if @user && @user.authenticate(login_params[:password])
      log_in(@user)
      flash[:success] = "Login successful"
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
    params.require(:login_form).permit(:email, :password)
  end

  def form_errors
    flash.now[:warning] = 'Oops, something went wrong'
    render :new
  end
end
