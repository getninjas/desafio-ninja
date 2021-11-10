class GuestMailer < ApplicationMailer
  def send_email(email)
    mail to: email, subject: 'Invite'
  end
end
