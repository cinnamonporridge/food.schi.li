class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  before_action :authenticate_user!

  private

  def authenticate_user!
    redirect_to login_url unless logged_in?
  end

  def authenticate_admin_user!
    redirect_to my_journal_days_path unless admin_logged_in?
  end

  def forward_logged_in!
    redirect_to my_journal_days_path if logged_in?
  end
end
