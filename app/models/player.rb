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
  has_many :booked_gigs, class_name: "Gig", foreign_key: :booked_by_id
  has_and_belongs_to_many :bands, -> { alpha }
  has_and_belongs_to_many :instruments

  # Validations
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :suspended, inclusion: { in: [ false ], message: "cannot be enabled for an admin" }, if: :admin?
  validate :suspension_requires_admin, if: :suspension_changing?

  attr_accessor :suspension_admin

  after_save :record_suspension_event, if: :suspension_changed?

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
    ClearanceMailer.change_password(self).deliver_now
  end

  def suspend!(by:)
    change_suspension!(true, by: by)
  end

  def restore!(by:)
    change_suspension!(false, by: by)
  end

  private

  def change_suspension!(suspended, by:)
    with_lock do
      self.suspension_admin = by
      attributes = { suspended: suspended }
      attributes[:remember_token] = Clearance::Token.new if suspended && !suspended?
      update!(attributes)
    end
  ensure
    self.suspension_admin = nil
  end

  def suspension_changing?
    will_save_change_to_suspended? && (suspended? || suspended_in_database == true)
  end

  def suspension_changed?
    saved_change_to_suspended? && (suspended? || suspended_before_last_save == true)
  end

  def suspension_requires_admin
    unless suspension_admin&.persisted? && suspension_admin.admin? && !suspension_admin.suspended?
      errors.add(:suspended, "can only be changed by an active admin")
    end
  end

  def record_suspension_event
    UserSuspensionEvent.create!(player_id: id, admin_id: suspension_admin.id,
      action: suspended? ? "suspended" : "restored")
  end
end
