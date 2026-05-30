module Clearance
  class PasswordMailer < ActionMailer::Base
    def change_password(user)
      @user = user
      user.send_password_reset_email
      mail(to: user.email, subject: "Change your password")
    end
  end
end