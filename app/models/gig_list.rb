class GigList < ApplicationRecord
  belongs_to :gig
  belongs_to :list

  validates :position, presence: true
  validates :list_id, uniqueness: { scope: :gig_id }
end
