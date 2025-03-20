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
  end

  # GET /songs/1/edit
  def edit
  end

  # POST /songs or /songs.json
  def create
    @song = Song.new(song_params)

    respond_to do |format|
      if @song.save
        format.html { redirect_to @song, notice: "Song was successfully created." }
        format.json { render :show, status: :created, location: @song }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @song.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /songs/1 or /songs/1.json
  def update
    respond_to do |format|
      if @song.update(song_params)
        format.html { redirect_to @song, notice: "Song was successfully updated." }
        format.json { render :show, status: :ok, location: @song }
      else
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
      params.require(:song).permit(:title, :performer, :version, :duration, :intro, :band_id)
    end
end
