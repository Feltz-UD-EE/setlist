class BandInvitationsController < ApplicationController
  def new
    @band = Band.find(params[:band_id])
    authorize_band!(@band)
    prepare_invitation_form
  end

  def create
    @band = Band.find(params[:band_id])
    authorize_band!(@band)
    prepare_invitation_form

    if @invitee_name.blank? || @invitee_email.blank?
      flash.now[:alert] = "Enter a name and email address for the invitation."
      render :new, status: :unprocessable_entity
      return
    end

    @invitation = @band.band_invitations.create!(
      invitee_name: @invitee_name,
      invitee_email: @invitee_email
    )
    @invite_url = sign_up_url(invite: @invitation.token)
    @email_body = invitation_body(@invite_url)
    BandInvitationMailer.with(
      band: @band,
      invitee_email: @invitee_email,
      invitee_name: @invitee_name,
      invite_url: @invite_url
    ).invite.deliver_now
    flash.now[:notice] = "Invitation sent to #{@invitee_email}."

    render :new, status: :created
  end

  private

  def prepare_invitation_form
    @invitee_name = invitation_params[:name].to_s.strip
    @invitee_email = invitation_params[:email].to_s.strip
    @invite_url = "[account creation link]"
    @email_body = invitation_body(@invite_url)
  end

  def invitation_params
    params.fetch(:invitation, ActionController::Parameters.new).permit(:name, :email)
  end

  def invitation_body(invite_url)
    <<~BODY
      Hello #{@invitee_name.presence || "<name>"}!

      You've been invited to join Setlist, a service for managing your performance and rehearsal music.  The band that invited you is #{@band.name}.

      Please click on the link below to create your account - this invitation expires in 14 days.

      #{invite_url}

      Setlist is currently in closed beta - please submit any bugs or feature requests to the site creators.

      Welcome and enjoy!
    BODY
  end
end
