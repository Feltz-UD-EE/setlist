module Admin
  class UserSuspensionEventsController < ApplicationController
    before_action :require_admin

    def index
      @events = UserSuspensionEvent.order(created_at: :desc, id: :desc)
    end

    private

    def require_admin
      head :forbidden unless admin?
    end
  end
end
