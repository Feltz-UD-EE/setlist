class Gig < ApplicationRecord
  belongs_to :band
  belongs_to :booked_by, class_name: "Player"
  has_many :gig_lists, dependent: :destroy
  has_many :lists, -> { order("gig_lists.position ASC") }, through: :gig_lists

  validates :date, :client, :contact, :band, :booked_by, presence: true
  validate :times_are_in_sequence

  scope :past, -> { where("date < ?", Date.current).order(date: :desc, start: :desc, id: :desc) }
  scope :upcoming, -> { where("date >= ?", Date.current).order(date: :asc, loadin: :asc, start: :asc, id: :asc) }

  def past?
    date.present? && date < Date.current
  end

  def upcoming?
    date.present? && date >= Date.current
  end

  def copy_for_rebooking(player)
    dup.tap do |copied_gig|
      copied_gig.date = nil
      copied_gig.retrospective = nil
      copied_gig.booked_by = player
    end
  end

  private

  def times_are_in_sequence
    if loadin.present? && soundcheck.present? && soundcheck <= loadin
      errors.add(:soundcheck, "must be later than load-in")
    end

    if loadin.present? && start.present? && start <= loadin
      errors.add(:start, "must be later than load-in")
    end

    if loadin.present? && self.end.present? && self.end <= loadin
      errors.add(:end, "must be later than load-in")
    end

    if soundcheck.present? && start.blank?
      errors.add(:start, "must be present when soundcheck is present")
    end

    if soundcheck.present? && start.present? && start <= soundcheck
      errors.add(:start, "must be later than soundcheck")
    end

    if start.present? && self.end.present? && self.end <= start
      errors.add(:end, "must be later than start")
    end
  end
end
