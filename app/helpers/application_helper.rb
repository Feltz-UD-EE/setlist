module ApplicationHelper
  def gig_time_field_value(gig, field)
    value = gig.public_send(field)
    return value.strftime("%H:%M") if value.present?
    return unless gig.new_record?

    {
      loadin: "16:00",
      soundcheck: "17:00",
      start: "19:00",
      end: "23:00"
    }[field]
  end
end
