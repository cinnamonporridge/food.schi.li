class ResetPasswordsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new, :create]

  def new
    @form = ResetPasswordForm.new(challenge: params[:challenge])
  end

  def create
    @form = ResetPasswordForm.new(reset_password_params)

    if @form.save
      log_in(@form.user)
      flash[:notice] = t(".success")
      redirect_to journal_days_path
    else
      flash.now[:notice] = t("shared.errors.oops")
      render :new
    end
  end

  private

  def reset_password_params
    params.expect(reset_password_form: [:password, :challenge])
  end
end
