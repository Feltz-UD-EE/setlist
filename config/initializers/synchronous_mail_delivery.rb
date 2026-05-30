# Solid Queue is not running, so we override deliver_later to behave like
# deliver_now. This ensures password reset emails (sent via Clearance's
# deliver_later call) are dispatched synchronously through SMTP without
# requiring a background job queue.
module ActionMailer
  class MessageDelivery
    def deliver_later(options = {})
      deliver_now
    end
  end
end
