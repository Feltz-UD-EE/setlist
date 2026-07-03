class GigMailer < ApplicationMailer
  def gig_created
    @gig = params[:gig]

    mail(
      to: params[:recipients],
      subject: "New Gig - #{@gig.date.strftime('%b %-d, %Y')}"
    )
  end

  def gig_updated
    @gig = params[:gig]

    mail(
      to: params[:recipients],
      subject: "Updated gig info - #{@gig.date.strftime('%b %-d, %Y')}"
    )
  end
end
