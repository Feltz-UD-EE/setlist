# Solid Queue is not running, so we override deliver_later to behave like
# deliver_now. This ensures any mailer that calls deliver_later is dispatched
# synchronously through SMTP without requiring a background job queue.
#
# NOTE: Password reset emails are also forced synchronous at the model level
# (Player#send_password_reset_email) to handle cases where Clearance calls
# deliver_now directly. This initializer is a belt-and-suspenders fallback.
module ActionMailer
  class MessageDelivery
    def deliver_later(options = {})
      mailer_info = "#{@mailer_class}##{@action}"
      Rails.logger.info("[SynchronousMailDelivery] deliver_later intercepted — delivering synchronously (#{mailer_info})")
      deliver_now.tap do
        Rails.logger.info("[SynchronousMailDelivery] deliver_now completed (#{mailer_info})")
      end
    end
  end
end
