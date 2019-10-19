class ResetPasswordsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new, :create]

  def new
    @form = ResetPasswordForm.new(challenge: params[:challenge])
  end

  def create
    @form = ResetPasswordForm.new(reset_password_params)
    return invalid_form_error unless @form.valid?

    user = User.find_by(reset_password_challenge: @form.challenge)
    return challenge_not_valid_error unless user&.requested_reset_link?

    user.password = @form.password

    if user.save!
      log_in(user)
      user.clear_reset_password!
      flash[:success] = 'Password successfully reset and logged in'
      redirect_to my_journal_days_path
    else
      flash.now[:alert] = 'Oops, something went wrong'
      render :new
    end
  end

  private

  def reset_password_params
    params.require(:reset_password_form).permit(:password, :challenge)
  end

  def reset_link_is_valid?
    @user&.requested_reset_link?
  end

  def invalid_form_error
    flash.now[:warning] = 'Oops, something went wrong'
    render :new
  end

  def challenge_not_valid_error
    flash.now[:warning] = 'The provided challenge is not valid. Please reset your password again.'
    render :new
  end
end
