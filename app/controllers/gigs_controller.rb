class GigsController < ApplicationController
  before_action :set_gig, only: %i[ show edit update rebook retrospective update_retrospective ]
  before_action :authorize_gig!, only: %i[ show edit update rebook retrospective update_retrospective ]

  def show
  end

  def new
    @band = Band.find(params[:band_id])
    authorize_band!(@band)
    @gig = build_new_gig
    prepare_setlist_builder
  end

  def edit
    @band = @gig.band
    @source_gig = source_gig
    prepare_setlist_builder
  end

  def create
    @gig = Gig.new(gig_params)
    @gig.booked_by = current_user
    authorize_band!(@gig.band)

    respond_to do |format|
      if save_gig_with_setlists
        send_gig_email(:created)
        format.html { redirect_to @gig, notice: "Gig was successfully created." }
        format.json { render :show, status: :created, location: @gig }
      else
        @band = @gig.band
        prepare_setlist_builder
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @gig.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @gig.assign_attributes(gig_params)
    authorize_band!(@gig.band)

    respond_to do |format|
      if save_gig_with_setlists
        send_gig_email(:updated)
        format.html { redirect_to @gig, notice: "Gig was successfully updated." }
        format.json { render :show, status: :ok, location: @gig }
      else
        @band = @gig.band
        prepare_setlist_builder
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @gig.errors, status: :unprocessable_entity }
      end
    end
  end

  def past
    @band = filtered_band
    @gigs = scoped_gigs.past
  end

  def upcoming
    @band = filtered_band
    @gigs = scoped_gigs.upcoming
  end

  def rebook
    copied_gig = nil

    Gig.transaction do
      copied_gig = @gig.copy_for_rebooking(current_user)
      copied_gig.date = Date.current
      copied_gig.save!

      @gig.gig_lists.order(:position, :id).each do |gig_list|
        copied_gig.gig_lists.create!(
          list: gig_list.list,
          position: gig_list.position
        )
      end
    end

    redirect_to edit_gig_path(copied_gig, source_gig_id: @gig.id), notice: "Gig was successfully rebooked."
  end

  def retrospective
    redirect_to @gig unless @gig.past?
  end

  def update_retrospective
    if @gig.update(retrospective_params)
      redirect_to @gig, notice: "Retrospective was successfully saved."
    else
      render :retrospective, status: :unprocessable_entity
    end
  end

  private

  def set_gig
    @gig = Gig.find(params[:id])
  end

  def authorize_gig!
    authorize_band!(@gig.band)
  end

  def gig_params
    params.require(:gig).permit(
      :date,
      :band_id,
      :client,
      :contact,
      :phone,
      :address,
      :fee,
      :venue,
      :loadin,
      :soundcheck,
      :start,
      :end,
      :notes
    )
  end

  def retrospective_params
    params.require(:gig).permit(:retrospective)
  end

  def selected_list_ids
    Array(params[:gig_list_ids]).reject(&:blank?)
  end

  def save_gig_with_setlists
    Gig.transaction do
      @gig.save!
      @gig.gig_lists.destroy_all
      selected_list_ids.each_with_index do |list_id, index|
        @gig.gig_lists.create!(list_id: list_id, position: index + 1)
      end
    end
    true
  rescue ActiveRecord::RecordInvalid
    false
  end

  def prepare_setlist_builder
    @band ||= @gig.band
    @band_lists = @band.present? ? @band.lists.alpha : List.none
    @band_list_by_id = @band_lists.index_by(&:id)
    @selected_list_ids = if params.key?(:gig_list_ids)
      selected_list_ids
    elsif @gig.persisted?
      @gig.gig_lists.order(:position).pluck(:list_id)
    else
      []
    end
  end

  def build_new_gig
    if params[:source_gig_id].present?
      original = Gig.find(params[:source_gig_id])
      authorize_band!(original.band)
      @source_gig = original
      original.copy_for_rebooking(current_user).tap do |gig|
        gig.band = @band
        gig.date = Date.current
      end
    else
      Gig.new(band: @band, booked_by: current_user)
    end
  end

  def source_gig
    return if params[:source_gig_id].blank?

    Gig.find(params[:source_gig_id]).tap { |gig| authorize_band!(gig.band) }
  end

  def filtered_band
    return if params[:band_id].blank?

    Band.find(params[:band_id]).tap { |band| authorize_band!(band) }
  end

  def scoped_gigs
    scope = Gig.where(band_id: accessible_bands.select(:id))
    @band.present? ? scope.where(band_id: @band.id) : scope
  end

  def send_gig_email(kind)
    return unless @gig.upcoming?

    recipients = @gig.band.players.pluck(:email).compact_blank.uniq
    return if recipients.empty?

    mailer = kind == :created ? :gig_created : :gig_updated
    GigMailer.with(gig: @gig, recipients: recipients).public_send(mailer).deliver_now
  end
end
