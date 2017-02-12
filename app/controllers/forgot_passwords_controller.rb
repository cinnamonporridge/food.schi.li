class ForgotPasswordsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: forgot_password_params[:email])
    if params[:magic_link]
      MagicLinkService.new(@user).call
      flash[:success] = 'We have sent a magic link to your email address'
    else
      ResetPasswordService.new(@user).call
      flash[:success] = 'A reset link has been sent to your email address'
    end

    redirect_to login_url
  end

  private

  def forgot_password_params
    params.require(:forgot_password).permit(:email)
  end
end
