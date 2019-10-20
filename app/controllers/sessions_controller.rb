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

    return handle_success if @user&.authenticate(login_params[:password])

    flash.now[:warning] = 'Invalid email or password'
    render :new
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

  def handle_success
    log_in(@user)
    redirect_to my_journal_days_path, success: 'Login successful'
  end
end
