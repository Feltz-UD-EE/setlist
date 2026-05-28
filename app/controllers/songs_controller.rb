class SongsController < ApplicationController
  before_action :set_song, only: %i[ show edit update destroy ]

  # GET /songs or /songs.json
  def index
    if params['band_id'].present?
      @band = Band.find(params['band_id'])
      authorize_band!(@band)
      @songs = @band.songs.alpha
      @title = @band.name + " Songs"
    else
      @songs = Song.where(band_id: accessible_bands.select(:id)).alpha
      @title = "All Songs"
    end
  end

  # GET /songs/1 or /songs/1.json
  def show
    @preparations = @song.preparations
    authorize_band!(@song.band)
    @main_sheets = @song.main_sheets
    @alternate_sheet_groups = @song.alternate_sheet_groups
  end

  # GET /songs/new
  def new
    if params['band_id'].present?
      @band = Band.find(params['band_id'])
      authorize_band!(@band)
      @song = Song.new(band_id: params['band_id'])
      @title = "New song for " + @band.name
    else
      @song = Song.new
      @title = "New song"
    end
    prepare_song_form
  end

  # GET /songs/1/edit
  def edit
    authorize_band!(@song.band)
    prepare_song_form
  end

  # POST /songs or /songs.json
  def create
    @song = Song.new(song_params)
    authorize_band!(@song.band)
    respond_to do |format|
      if save_song_with_sheets
        format.html { redirect_to @song, notice: "Song was successfully created." }
        format.json { render :show, status: :created, location: @song }
      else
        prepare_song_form
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @song.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /songs/1 or /songs/1.json
  def update
    @song.assign_attributes(song_params)
    authorize_band!(@song.band)

    respond_to do |format|
      if save_song_with_sheets
        format.html { redirect_to @song, notice: "Song was successfully updated." }
        format.json { render :show, status: :ok, location: @song }
      else
        prepare_song_form
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @song.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /songs/1 or /songs/1.json
  def destroy
    authorize_band!(@song.band)
    @song.destroy!

    respond_to do |format|
      format.html { redirect_to songs_path, status: :see_other, notice: "Song was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_song
      @song = Song.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def song_params
      params.require(:song).permit(:title, :performer, :version, :duration, :intro, :finish, :band_id)
    end

    def save_song_with_sheets
      Song.transaction do
        @song.save!
        update_existing_sheets
        attach_main_sheet
        attach_alternate_sheet
      end
      true
    rescue ActiveRecord::RecordInvalid => error
      @song.errors.add(:base, error.record.errors.full_messages.to_sentence) unless error.record == @song
      false
    end

    def attach_main_sheet
      sheet_upload = params.dig(:song, :sheet_img)
      return if sheet_upload.blank?

      @song.sheets.create!(
        img: sheet_upload,
        sort_order: params.dig(:song, :sheet_sort_order).presence || next_sheet_sort_order,
        instrument_ids: []
      )
    end

    def attach_alternate_sheet
      sheet_upload = params.dig(:song, :alternate_sheet_img)
      instrument_ids = sheet_instrument_ids(params.dig(:song, :alternate_sheet_instrument_ids))
      return if sheet_upload.blank?

      if instrument_ids.blank?
        @song.errors.add(:base, "Choose at least one instrument for an alternate sheet.")
        raise ActiveRecord::RecordInvalid.new(@song)
      end

      @song.sheets.create!(
        img: sheet_upload,
        sort_order: params.dig(:song, :alternate_sheet_sort_order).presence || next_sheet_sort_order,
        instrument_ids: instrument_ids
      )
    end

    def update_existing_sheets
      sheet_update_params.each do |sheet_id, sheet_params|
        sheet = @song.sheets.find(sheet_id)
        if sheet_params[:delete] == "1"
          sheet.destroy!
          next
        end

        update_attributes = { sort_order: sheet_params[:sort_order].presence || sheet.sort_order }
        update_attributes[:img] = sheet_params[:img] if sheet_params[:img].present?
        update_attributes[:instrument_ids] = sheet_instrument_ids(sheet_params[:instrument_ids])
        sheet.update!(update_attributes)
      end
    end

    def sheet_update_params
      params[:sheets].present? ? params.require(:sheets).permit! : {}
    end

    def sheet_instrument_ids(raw_ids)
      Array(raw_ids).reject(&:blank?).map(&:to_i)
    end

    def next_sheet_sort_order
      @song.main_sheets.maximum(:sort_order).to_i + 1
    end

    def prepare_song_form
      @sheets = @song.persisted? ? @song.sheets.includes(:instruments).by_sort_order : Sheet.none
      @instruments = Instrument.alpha
      @title ||= @song.band.present? ? "New song for #{@song.band.name}" : "New song"
    end
end
