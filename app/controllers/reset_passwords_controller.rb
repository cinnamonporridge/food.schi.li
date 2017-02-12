class ResetPasswordsController < ApplicationController
  def new
    @user = User.find_by(reset_password_challenge: params[:challenge])
    if reset_link_is_valid?
      @form = ResetPasswordsForm.new(@user)
    else
      flash[:warning] = 'Reset link is not valid'
      redirect_to login_url
    end
  end

  def create

  end

  private

  def reset_link_is_valid?
    @user && @user.requested_reset_link?
  end
end
