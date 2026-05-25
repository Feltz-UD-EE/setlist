class ApplicationController < ActionController::Base
  include Clearance::Controller
  before_action :require_login, unless: :public_controller?
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  helper_method :current_band

  private

  def public_controller?
    controller_path.start_with?("clearance/") ||
      controller_path == "static" ||
      controller_path == "registrations"
  end

  def current_band
    current_user&.band
  end

  def admin?
    current_user&.admin?
  end

  def accessible_bands
    admin? ? Band.all : Band.where(id: current_user.band_id)
  end

  def authorize_band!(band)
    return if admin? || band == current_user.band

    deny_access("You do not have access to that band.")
  end
end
