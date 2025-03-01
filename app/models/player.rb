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
  # Statics & enums

  # Relations
  # has_many :preparations...  complicated join
  belongs_to :band
  has_and_belongs_to_many :instruments

  # Validations
  validates :first_name, presence: true
  validates :last_name, presence: true

  # Scopes
  scope :alpha, -> { order(last_name: :asc) }

  # Class methods

  # Instance methods
  def formatted_name
    return "#{first_name} #{last_name}"
  end

  # Callbacks
end
