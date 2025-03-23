#
# Copyright 2025 John C. Feltz, github: Feltz-UD-EE/setlist
#
# Page: An uploaded image of a sheet of music
#
# t.integer :sort_order
# t.references :instrument
# t.string :img               uploaded file managed by carrierwave gem
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
  # 2-attribute validation of instrument_id and sort_order - need to make instrument_id == nil condition works
  validates :sort_order, uniqueness: {scope: :instrument_id}

  # Scopes
  scope :by_sort_order, -> { order(sort_order: :asc) }
  scope :without_instrument, -> { where(instrument_id: nil) }
  scope :with_instrument, -> { where.not(instrument_id: nil).order(instrument_id: :asc) }
  # TODO scope with parameter of pages for specified instrument(s).  Hopefully won't be a big problem:
  # only 1 or 2 instruments with special pages, and instrument_ids wont include more than 1 instrument
  # with such a page.  Leave it to the DB order and then deal with it when/if it actually happens.

  # Class methods

  # Instance methods

  # Callbacks
end
