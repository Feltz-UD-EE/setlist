module Admin
  class UserPasswordControlsController < ApplicationController
    before_action :require_admin

    def index
      @players = Player.includes(:bands, :band).order(:id)
    end

    def reset_password
      player = Player.find(params[:id])
      player.forgot_password!
      player.send_password_reset_email

      redirect_to admin_user_password_controls_path,
        notice: "Password reset email sent to #{player.email}.", status: :see_other
    end

    def suspend
      player = Player.find(params[:id])
      return head :forbidden if player.admin?

      player.suspend!(by: current_user)

      redirect_to admin_user_password_controls_path,
        notice: "#{player.email} has been suspended.", status: :see_other
    end

    def restore
      player = Player.find(params[:id])
      player.restore!(by: current_user)

      redirect_to admin_user_password_controls_path,
        notice: "#{player.email} has been restored.", status: :see_other
    end

    private

    def require_admin
      head :forbidden unless admin?
    end
  end
end
