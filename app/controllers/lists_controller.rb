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
    @band = Band.find(params[:band_id]) if params[:band_id].present?
    @list = List.new(band: @band)
    prepare_song_builder
  end

  # GET /lists/1/edit
  def edit
    @band = @list.band
    prepare_song_builder
  end

  # POST /lists or /lists.json
  def create
    @list = List.new(list_params)
    respond_to do |format|
      if save_list_with_songs
        format.html { redirect_to @list, notice: "List was successfully created." }
        format.json { render :show, status: :created, location: @list }
      else
        @band = @list.band
        prepare_song_builder
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @list.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lists/1 or /lists/1.json
  def update
    @list.assign_attributes(list_params)

    respond_to do |format|
      if save_list_with_songs
        format.html { redirect_to @list, notice: "List was successfully updated." }
        format.json { render :show, status: :ok, location: @list }
      else
        @band = @list.band
        prepare_song_builder
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_list
      @list = List.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def list_params
      params.require(:list).permit(:name, :notes, :band_id)
    end

    def selected_song_ids
      Array(params[:list_song_ids]).reject(&:blank?)
    end

    def save_list_with_songs
      List.transaction do
        @list.save!
        @list.list_songs.destroy_all
        selected_song_ids.each_with_index do |song_id, index|
          @list.list_songs.create!(song_id: song_id, position: index + 1)
        end
      end
      true
    rescue ActiveRecord::RecordInvalid
      false
    end

    def prepare_song_builder
      @band ||= @list.band
      @band_songs = @band.present? ? @band.songs.alpha : Song.none
      @band_song_by_id = @band_songs.index_by(&:id)
      @selected_song_ids = if params.key?(:list_song_ids)
        selected_song_ids
      elsif @list.persisted?
        @list.list_songs.order(:position).pluck(:song_id)
      else
        []
      end
    end
end
