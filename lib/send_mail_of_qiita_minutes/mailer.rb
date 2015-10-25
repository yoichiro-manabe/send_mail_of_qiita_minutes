require 'action_mailer'

module SendMailOfQiitaMinutes

  ActionMailer::Base.delivery_method = :smtp

  class Mailer < ActionMailer::Base
    def send_email(email_addresses:, from:, subject:, body: )
      mail(
          to: email_addresses,
          from: from,
          subject: subject
      ) do |format|
        format.html {render text: body}
      end
    end
  end
end