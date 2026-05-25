class BandInvitationsController < ApplicationController
  def new
    @band = Band.find(params[:band_id])
    authorize_band!(@band)
    @invitation = @band.band_invitations.create!
    @invite_url = sign_up_url(invite: @invitation.token)
    @mailto_href = "mailto:?subject=#{ERB::Util.url_encode("Join #{@band.name} on Setlist")}&body=#{ERB::Util.url_encode(invitation_body)}"
  end

  private

  def invitation_body
    <<~BODY
      You have been invited to join #{@band.name} on Setlist.

      Use this one-time account creation link:
      #{@invite_url}

      This invitation expires on #{@invitation.expires_at.strftime("%B %-d, %Y")}.
    BODY
  end
end
