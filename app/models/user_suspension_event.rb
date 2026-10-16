class UserSuspensionEvent < ApplicationRecord
  validates :player_id, :admin_id, presence: true
  validates :action, inclusion: { in: %w[suspended restored] }
end
