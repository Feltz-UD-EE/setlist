class SongsController < ApplicationController
  before_action :set_song, only: %i[ show edit update destroy ]

  # GET /songs or /songs.json
  def index
    if params['band_id'].present?
      @band = Band.find(params['band_id'])
      @songs = @band.songs.alpha
      @title = @band.name + " Songs"
    else
      @songs = Song.all.alpha
      @title = "All Songs"
    end
  end

  # GET /songs/1 or /songs/1.json
  def show
    @preparations = @song.preparations
    # TODO figure out how to manage generic pages vs. pages tied to an instrument
    @pages = @song.pages
  end

  # GET /songs/new
  def new
    if params['band_id'].present?
      @band = Band.find(params['band_id'])
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
    prepare_song_form
  end

  # POST /songs or /songs.json
  def create
    @song = Song.new(song_params)
    respond_to do |format|
      if save_song_with_page
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

    respond_to do |format|
      if save_song_with_page
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

    def page_image_param
      params.dig(:song, :page_img)
    end

    def save_song_with_page
      Song.transaction do
        @song.save!
        attach_page_image if page_image_param.present?
      end
      true
    rescue ActiveRecord::RecordInvalid => error
      @song.errors.add(:base, error.record.errors.full_messages.to_sentence) unless error.record == @song
      false
    end

    def attach_page_image
      @song.pages.create!(
        img: page_image_param,
        sort_order: next_page_sort_order
      )
    end

    def next_page_sort_order
      @song.pages.maximum(:sort_order).to_i + 1
    end

    def prepare_song_form
      @pages = @song.persisted? ? @song.pages.by_sort_order : Page.none
      @title ||= @song.band.present? ? "New song for #{@song.band.name}" : "New song"
    end
end
