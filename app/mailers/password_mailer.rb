class PasswordMailer < ApplicationMailer
  def reset_link_mail(user)
    @user = user
    mail(to: @user.email, subject: 'Your password reset link')
  end

  def magic_link_mail(user)
    @user = user
    mail(to: @user.email, subject: 'Your magic link')
  end
end
