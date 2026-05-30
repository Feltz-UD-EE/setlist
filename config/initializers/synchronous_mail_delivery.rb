# Solid Queue is not running, so we override deliver_later to behave like
# deliver_now. This ensures password reset emails (sent via Clearance's
# deliver_later call) are dispatched synchronously through SMTP without
# requiring a background job queue.
module ActionMailer
  class MessageDelivery
    def deliver_later(options = {})
      Rails.logger.info("[SynchronousMailDelivery] deliver_later called — redirecting to deliver_now (mailer=#{@mailer_class}, action=#{@action})")
      deliver_now.tap do
        Rails.logger.info("[SynchronousMailDelivery] deliver_now completed (mailer=#{@mailer_class}, action=#{@action})")
      end
    end
  end
end
