class SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new, :create]
  before_action :forward_logged_in!, except: [:destroy]

  def new
    @form = LoginForm.new
  end

  def create
    @form = LoginForm.new(login_params)
    return form_errors unless @form.valid?

    user = User.find_by(email: @form.email)

    if user_not_global_and_authenticated?(user)
      log_in(user)
      redirect_to journal_days_path, notice: t('.success')
    else
      flash.now[:notice] = t('.invalid_email_or_password')
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
    flash.now[:notice] = t('shared.errors.oops')
    render :new
  end

  def user_not_global_and_authenticated?(user)
    !user&.global_user? && user&.authenticate(login_params[:password])
  end
end
