class ResetPasswordsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new, :create]

  def new
    @form = ResetPasswordForm.new(challenge: params[:challenge])
  end

  def create
    @form = ResetPasswordForm.new(reset_password_params)

    if @form.save
      log_in(@form.user)
      flash[:success] = 'Password successfully reset and logged in'
      redirect_to journal_days_path
    else
      flash.now[:warning] = 'Oops, something went wrong'
      render :new
    end
  end

  private

  def reset_password_params
    params.require(:reset_password_form).permit(:password, :challenge)
  end
end
