class RegistrationsController < ApplicationController
  def new
    @invite_token = params[:invite]
    @invitation = BandInvitation.find_available(@invite_token) if @invite_token.present?
    unless @invitation.present?
      redirect_to public_home_path, alert: "Account creation is currently by invitation only."
      return
    end

    @player = Player.new
  end

  def create
    @invite_token = params[:invite]
    @invitation = BandInvitation.find_available(@invite_token)

    if @invitation.blank?
      redirect_to public_home_path, alert: "Account creation is currently by invitation only."
      return
    end

    @player = @invitation.band.players.build(registration_params)
    @player.invitation_accepted_at = Time.current

    Player.transaction do
      @player.save!
      @invitation.mark_used!
    end

    sign_in @player
    redirect_to @player.band, notice: "Welcome to Setlist."
  rescue ActiveRecord::RecordInvalid
    render :new, status: :unprocessable_entity
  end

  private

  def registration_params
    params.require(:player).permit(:first_name, :last_name, :email, :password)
  end
end
