#
# Copyright 2025 John C. Feltz, github: Feltz-UD-EE/setlist
#
# Page: An uploaded image of a sheet of music
#
# t.integer :sort_order
# t.references :instrument
# t.string :
# t.timestamps
##
class Page < ApplicationRecord
  # image file uploads
  mount_uploader :img, ImgUploader
  # Statics & enums

  # Relations
  belongs_to :song
  belongs_to :instrument, optional: true

  # Validations

  # Scopes
  scope :order, -> { order(sort_order: :asc) }
  scope :without_instrument, -> { where(instrument_id: nil) }
  scope :with_instrument, -> { where.not(instrument_id: nil).order(instrument_id: :asc) }

  # Class methods

  # Instance methods

  # Callbacks
end
