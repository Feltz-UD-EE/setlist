class ListsController < ApplicationController
  before_action :set_list, only: %i[ show edit update destroy ]

  # GET /lists or /lists.json
  def index
    @lists = List.all
  end

  # GET /lists/1 or /lists/1.json
  def show
    @songs = @list.songs
  end

  # GET /lists/new
  def new
    @list = List.new
  end

  # GET /lists/1/edit
  def edit
  end

  # POST /lists or /lists.json
  def create
    @list = List.new(list_params)

    respond_to do |format|
      if @list.save
        format.html { redirect_to @list, notice: "List was successfully created." }
        format.json { render :show, status: :created, location: @list }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @list.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lists/1 or /lists/1.json
  def update
    respond_to do |format|
      if @list.update(list_params)
        format.html { redirect_to @list, notice: "List was successfully updated." }
        format.json { render :show, status: :ok, location: @list }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lists/1 or /lists/1.json
  def destroy
    @list.destroy!

    respond_to do |format|
      format.html { redirect_to lists_path, status: :see_other, notice: "List was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # Select a list to play through (w/ 0-n instruments): renders the #play action after submitting form
  def start
    @lists =  List.all.alpha    # TODO add current_user/current_band logic here
    @instruments = Instrument.all.alpha
  end

  # Shows the list of songs with prep for selected instruments
  # Paging through each song is with param[song_sequence]
  # TODO check for off-by-one errors
  # TODO figure out paradigm for no instruments vs some instruments vs all instruments
  # TODO refactor instrument & prep stuff into model methods
  def play
    @list = List.find(params[:list_id])
    print(@list)
    print(params[:instrument_ids])
    @instrument_ids = (params[:instrument_ids]).delete("")
    print(@instrument_ids)
    @preps = []
    @next_preps = []
    if @instrument_ids.present?
      @instrument_list = Instrument.where("id in (#{@instrument_ids.join(',')})").pluck(:name).join(', ')
    end
    if params[:song_sequence].present?
      @sequence = params[song_sequence]
      @song = @list.songs[@sequence.to_i]
      if @instrument_ids.present?
        @preps = @song.preparations.where("instrument_id in (#{@instrument_ids.join(',')})")
      end
      if @sequence <= @list.length
        @next_song = @list.songs[@sequence.to_i + 1]
        if @instrument_ids.present?
          @next_preps = @next_song.preparations.where("instrument_id in (#{@instrument_ids.join(',')})")
        end
      end
      # render play
    else
      @song = @list.songs.first
      if @instrument_ids.present?
        @preps = @song.preparations.where("instrument_id in (#{instrument_ids.join(',')})")
      end

      # render play_song
    end
    print "About to render /play"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_list
      @list = List.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def list_params
      params.require(:player).permit(:name, :band_id, :song_sequence, instrument_ids: [])
    end
end
