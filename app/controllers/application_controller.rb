class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  around_action :switch_locale
  before_action :authenticate_user!

  def log_in(user)
    session[:user_id] = user.id
  end

  def log_out
    session.clear
    @current_user = nil
  end

  def switch_locale(&)
    locale = current_user&.locale || I18n.default_locale
    I18n.with_locale(locale, &)
  end

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    current_user.present?
  end

  def authenticate_user!
    redirect_to login_url unless logged_in?
  end

  def authenticate_admin_user!
    redirect_to journal_days_path unless current_user&.is_admin?
  end

  def forward_logged_in!
    redirect_to journal_days_path if logged_in?
  end
end
