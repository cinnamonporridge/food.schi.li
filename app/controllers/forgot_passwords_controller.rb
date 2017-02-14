class ForgotPasswordsController < ApplicationController

  skip_before_action :authenticate_user!, only: [:new, :create]

  def new
    @form = ForgotPasswordForm.new
  end

  def create
    @form = ForgotPasswordForm.new(forgot_password_params)

    return invalid_input_error unless @form.valid?

    @user = User.find_by(email: @form.email)
    if params[:magic_link]
      PasswordService.magic_link!(@user)
      flash[:success] = 'A magic link has been sent to your email address'
    else
      PasswordService.reset!(@user)
      flash[:success] = 'A reset link has been sent to your email address'
    end

    redirect_to login_url
  end

  private

  def forgot_password_params
    params.require(:forgot_password_form).permit(:email)
  end

  def invalid_input_error
    flash.now[:warning] = 'Oops, something went wrong'
    render :new
  end
end
