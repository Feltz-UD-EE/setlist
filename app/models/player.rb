#
# Copyright 2025 John C. Feltz, github: Feltz-UD-EE/setlist
#
# Player: A band member, who may play one or more instruments
  # t.string :first_name
  # t.string :last_name
  # t.references :band
  # t.timestamps
##

class Player < ApplicationRecord
  include Clearance::User
  # Statics & enums

  # Relations
  # has_many :preparations...  complicated join
  belongs_to :band, optional: true
  has_and_belongs_to_many :bands, -> { alpha }
  has_and_belongs_to_many :instruments

  # Validations
  validates :first_name, presence: true
  validates :last_name, presence: true

  # Scopes
  scope :alpha, -> { order(last_name: :asc) }

  # Class methods

  # Instance methods
  def admin?
    admin
  end

  def formatted_name
    return "#{first_name} #{last_name}"
  end

  def home_band
    band || bands.alpha.first
  end

  def member_of?(band)
    bands.exists?(band.id) || self.band == band
  end

  def send_password_reset_email
    Rails.logger.info("DEBUG: send_password_reset_email called for #{email}")
    Clearance::PasswordMailer.change_password(self).deliver_now
    Rails.logger.info("DEBUG: email delivered for #{email}")
  end

  def send_password_reset_on_change
    send_password_reset_email
  end


  after_update :log_changes

  def log_changes
    Rails.logger.info("DEBUG: Player #{email} updated. Changes: #{saved_changes.inspect}")
    if saved_change_to_encrypted_password?
      send_password_reset_email
    end
  end
  
  # Callbacks
  after_update :send_password_reset_on_update, if: :saved_change_to_encrypted_password?
end
