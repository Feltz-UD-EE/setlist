require "digest"
require "securerandom"

class BandInvitation < ApplicationRecord
  belongs_to :band

  TOKEN_TTL = 14.days

  validates :token_digest, presence: true, uniqueness: true
  validates :expires_at, presence: true
  validates :invitee_name, presence: true, on: :create
  validates :invitee_email, presence: true, on: :create

  attr_accessor :token

  before_validation :ensure_token, on: :create

  scope :available, -> { where(used_at: nil).where("expires_at > ?", Time.current) }
  scope :with_invitee_details, -> { where.not(invitee_name: [nil, ""]).where.not(invitee_email: [nil, ""]) }
  scope :oldest_first, -> { order(created_at: :asc) }
  scope :recent_first, -> { order(created_at: :desc) }

  def self.digest(token)
    Digest::SHA256.hexdigest(token.to_s)
  end

  def self.find_available(token)
    available.find_by(token_digest: digest(token))
  end

  def available?
    used_at.blank? && expires_at.future?
  end

  def mark_used!
    update!(used_at: Time.current)
  end

  private

  def ensure_token
    self.token ||= SecureRandom.urlsafe_base64(24)
    self.token_digest ||= self.class.digest(token)
    self.expires_at ||= TOKEN_TTL.from_now
  end
end
