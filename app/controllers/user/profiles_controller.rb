class User::ProfilesController < ApplicationController
  def show
    @form = UserProfileForm.new(current_user)
  end

  def update
    @form = UserProfileForm.new(current_user, params)

    @form.save
    redirect_to user_profile_path, notice: t('.success', locale: current_user.locale)
  end
end
