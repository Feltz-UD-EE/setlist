class PlayController < ApplicationController
  # Select a list to play through (w/ 0-n instruments): renders the #play action after submitting fo
  def choose
    if params[:list_id].present?
      @list_id = params[:list_id]
      @list_name = List.find(params[:list_id]).name
    else
      @lists =  List.all.alpha    # TODO add current_user/current_band logic here
    end
    @instruments = Instrument.all.alpha
    @display_types = [["Song by Song"], ["One Screen"]]
  end

  # POST from non-model form in #start
  # Just processes instrument_ids and redirects to #play
  def cue
    list = List.find(params[:list_id])
    instrument_ids = params[:instrument_ids]
    instrument_ids.delete("")
    if params[:display_type] == 'Song by Song'
      redirect_to controller: 'play', action: 'play', list_id: list.id, instrument_ids: instrument_ids
    elsif params[:display_type] == 'One Screen'
      redirect_to controller: 'play', action: 'play_all', list_id: list.id, instrument_ids: instrument_ids
    end
  end

  # Shows the list of songs with prep for selected instruments
  # TODO check for off-by-one errors
  # TODO figure out paradigm for no instruments vs some instruments vs all instruments
  # TODO refactor instrument & prep stuff into model methods
  def play
    @list = List.find(params[:list_id])
    @instrument_ids = (params[:instrument_ids])
    @preps = []
    @song = @list.songs.first
    if @instrument_ids.present?
      @instrument_list = Instrument.where("id in (#{@instrument_ids.join(',')})").pluck(:name).join(', ')
      @preps = @song.preparations.where("instrument_id in (#{@instrument_ids.join(',')})")
    end
  end

  # Shows an individual song, including prep & intro for the following song
  # TODO check for off-by-one errors
  # TODO figure out paradigm for no instruments vs some instruments vs all instruments
  # TODO refactor instrument & prep stuff into model methods
  # TODO handle instrument-specific pages
  def play_song
    @list = List.find(params[:list_id])
    @instrument_ids = (params[:instrument_ids])
    @preps = []
    @next_preps = []
    @sequence=params[:song_sequence].to_i
    @song = @list.songs[@sequence]
    if @sequence < @list.songs.length - 1
      @next_song = @list.songs[@sequence+1]
    end
    if @instrument_ids.present?
      @instrument_list = Instrument.where("id in (#{@instrument_ids.join(',')})").pluck(:name).join(', ')
      @preps = @song.preparations.where("instrument_id in (#{@instrument_ids.join(',')})")
      @next_preps = @next_song.preparations.where("instrument_id in (#{@instrument_ids.join(',')})") if @next_song.present?
    end
  end

# Shows entire setlist on one page, suggested by Chip.
# TODO: restructure the return data into a big JSON instead of 3 arrays?
# TODO handle instrument-specific pages
  def play_all
    @list = List.find(params[:list_id])
    @instrument_ids = (params[:instrument_ids])
    @songs = @list.songs
    @preps = []
    @pages = []
    if @instrument_ids.present?
      @instrument_list = Instrument.where("id in (#{@instrument_ids.join(',')})").pluck(:name).join(', ')
      @songs.each do |song|
        preps = song.preparations.where("instrument_id in (#{@instrument_ids.join(',')})")
        pages = song.pages
        @preps << preps
        @pages << pages
      end
    end
  end
end