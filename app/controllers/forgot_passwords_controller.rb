class ForgotPasswordsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new, :create]
  before_action :forward_logged_in!

  def new
    @form = ForgotPasswordForm.new
  end

  def create
    @form = ForgotPasswordForm.new(forgot_password_params)

    return invalid_input_error unless @form.valid?

    @user = User.find_by(email: @form.email)
    PasswordService.reset_link!(@user)
    flash[:notice] = t('.success')

    redirect_to login_url
  end

  private

  def forgot_password_params
    params.require(:forgot_password).permit(:email)
  end

  def invalid_input_error
    flash.now[:notice] = t('shared.errors.oops')
    render :new
  end
end
