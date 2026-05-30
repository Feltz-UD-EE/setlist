Clearance.configure do |config|
  config.user_model = "Player"
  config.mailer_sender = ENV.fetch("MAILER_SENDER", "reply@setlist.local")
  config.mailer = "ClearanceMailer"
  config.allow_sign_up = false
  config.routes = false
  config.cookie_expiration = ->(_cookies) { 30.days.from_now.utc }
  config.rotate_csrf_on_sign_in = true
end
