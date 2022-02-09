class PasswordMailer < ApplicationMailer
  def reset_link_mail(user)
    @user = user
    mail(to: @user.email, subject: 'Your password reset link')
  end
end
