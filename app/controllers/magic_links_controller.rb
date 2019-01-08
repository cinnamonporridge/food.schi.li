class MagicLinksController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new]

  def new
    user = User.find_by(magic_link_challenge: params[:challenge])

    if user
      log_in(user)
      user.clear_magic_link!
      flash[:success] = 'Login successful'
      redirect_to my_journal_days_path
    end

    flash.now[:warning] = 'Magic link challenge is not correct'
  end
end
