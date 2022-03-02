class PasswordMailer < ApplicationMailer
  def reset_link_mail(user)
    @user = user
    mail(to: @user.email, subject: t('.your_password_reset_link'))
  end
end
