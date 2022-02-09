# Preview all emails at http://localhost:3000/rails/mailers/password_mailer
class PasswordMailerPreview < ActionMailer::Preview
  def reset_link_mail
    user = User.first
    PasswordService.reset_link!(user)
    PasswordMailer.reset_link_mail(user)
  end
end
