#
# Copyright 2025 John C. Feltz, github: Feltz-UD-EE/setlist
#
# Song: lyrics and music for a song (optional sheet uploads)
  # t.string :title
  # t.string :version
  # t.string :performer
  # t.integer :duration
  # t.integer :tempo
  # t.string :intro
  # t.references :band
  # t.string :finish
  # t.timestamps
##

class Song < ApplicationRecord
  attr_accessor :sheet_img, :sheet_sort_order, :alternate_sheet_img, :alternate_sheet_sort_order, :alternate_sheet_instrument_ids

  # Statics & enums

  # Relations
  has_many :preparations
  belongs_to :band
  has_many :list_songs
  has_many :lists, through: :list_songs
  has_many :sheets, dependent: :destroy

  # Validations
  validates :title, presence: true

  # Scopes
  scope :alpha, -> { order(title: :asc) }
  scope :recent, -> { order(created_at: :desc) }

  # Class methods

  # Instance methods
  def duration_pretty
    seconds = duration % 60
    minutes = (duration/60)
    return format("%2d:%02d", minutes, seconds)
  end

  def main_sheets
    sheets.without_instrument.by_sort_order
  end

  def alternate_sheets
    sheets.with_instrument.by_sort_order
  end

  def alternate_sheets?
    alternate_sheets.exists?
  end

  def alternate_sheet_groups
    Instrument
      .joins(:sheet_instruments)
      .where(sheet_instruments: { sheet_id: alternate_sheets.reorder(nil).select(:id) })
      .distinct
      .alpha
      .each_with_object({}) do |instrument, groups|
        groups[instrument] = sheets
          .joins(:sheet_instruments)
          .where(sheet_instruments: { instrument_id: instrument.id })
          .by_sort_order
      end
  end

  def sheets_for_instruments(instrument_ids)
    selected_ids = Array(instrument_ids).reject(&:blank?).map(&:to_i)
    return main_sheets if selected_ids.blank?

    matching_alternates = sheets.joins(:instruments).where(instruments: { id: selected_ids }).distinct.by_sort_order
    replaced_sort_orders = matching_alternates.pluck(:sort_order)
    (main_sheets.where.not(sort_order: replaced_sort_orders).to_a + matching_alternates.to_a).sort_by { |sheet| [sheet.sort_order, sheet.id] }
  end
  # Callbacks
end
