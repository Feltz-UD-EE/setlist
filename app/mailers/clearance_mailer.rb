# Custom Clearance mailer configured via Clearance.configuration.mailer.
# Inherits all templates and behaviour from Clearance::Mailer but is
# resolved through Rails' autoloader so the app can override it freely.
class ClearanceMailer < Clearance::Mailer
end
