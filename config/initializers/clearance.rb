Clearance.configure do |config|
  config.user_model = "Player"
  config.mailer_sender = "reply@example.com"
  config.rotate_csrf_on_sign_in = true
end
