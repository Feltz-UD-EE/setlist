#
# Copyright 2025 John C. Feltz, github: Feltz-UD-EE/setlist
#
# Sheet: An uploaded file of song music or notes
#
# t.integer :sort_order
# t.references :instrument
# t.string :img               uploaded file managed by carrierwave gem
# t.timestamps
##
class Sheet < ApplicationRecord
  # sheet file uploads
  mount_uploader :img, ImgUploader

  # Statics & enums

  # Relations
  belongs_to :song
  belongs_to :instrument, optional: true
  has_many :sheet_instruments, dependent: :destroy
  has_many :instruments, through: :sheet_instruments

  # Validations
  validates :sort_order, presence: true

  # Scopes
  scope :by_sort_order, -> { order(sort_order: :asc) }
  scope :without_instrument, -> { left_outer_joins(:sheet_instruments).where(sheet_instruments: { id: nil }) }
  scope :with_instrument, -> { joins(:sheet_instruments).distinct }

  # Class methods

  # Instance methods
  def alternate?
    instruments.any?
  end

  def instrument_names
    instruments.alpha.pluck(:name).join(", ")
  end

  # Callbacks
end
