class BandInvitationMailer < ApplicationMailer
  default reply_to: "john.feltz+setlist@gmail.com"

  def invite
    @band = params[:band]
    @invitee_name = params[:invitee_name]
    @invite_url = params[:invite_url]

    mail(
      to: params[:invitee_email],
      subject: "Join #{@band.name} on Setlist"
    )
  end
end
