class UserProfileForm < ApplicationForm
  delegate :locale, to: :object

  def save
    object.locale = user_profile_params[:locale]
    super
  end

  private

  def user_profile_params
    params.require(:user_profile).permit(:locale)
  end
end
