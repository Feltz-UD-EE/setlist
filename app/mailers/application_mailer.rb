class ApplicationMailer < ActionMailer::Base
  default from: -> { ENV.fetch("MAILER_SENDER") { ENV.fetch("MAIL_FROM", "reply@setlist.local") } }
  layout "mailer"

  after_action :log_mail_delivery
  after_delivery :log_mail_delivery

  private

  def log_mail_delivery
    recipients = Array(message.to).join(", ")
    Rails.logger.info(
      "[Mailer] Delivering '#{message.subject}' " \
      "to=#{recipients} " \
      "from=#{message.from&.first}"
    )
  rescue => e
    Rails.logger.error("[Mailer] Failed to read mail metadata: #{e.class}: #{e.message}")
  end
end
