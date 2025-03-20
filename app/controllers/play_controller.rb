class PlayController < ApplicationController
  # Select a list to play through (w/ 0-n instruments): renders the #play action after submitting fo
  def choose
    print "Top of play#start"
    @lists =  List.all.alpha    # TODO add current_user/current_band logic here
    @instruments = Instrument.all.alpha
    print(@lists)
    print(@instruments)
  end

  # POST from non-model form in #start
  # Just processes instrument_ids and redirects to #play
  def cue
    print ("in play#cue")
    list = List.find(params[:list_id])
    print(list)
    print(params[:instrument_ids])
    instrument_ids = params[:instrument_ids]
    instrument_ids.delete("")
    print(instrument_ids)
    redirect_to controller: 'play', action: 'play', list_id: list.id, instrument_ids: instrument_ids
  end

  # Shows the list of songs with prep for selected instruments
  # TODO check for off-by-one errors
  # TODO figure out paradigm for no instruments vs some instruments vs all instruments
  # TODO refactor instrument & prep stuff into model methods
  def play
    print ("in play#play")
    @list = List.find(params[:list_id])
    print(@list)
    print(params[:instrument_ids])
    @instrument_ids = (params[:instrument_ids])
    print(@instrument_ids)
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
  def play_song
    print ("in play#play_song")
    @list = List.find(params[:list_id])
    print(@list)
    print(params[:instrument_ids])
    @instrument_ids = (params[:instrument_ids])
    print(@instrument_ids)
    @preps = []
    @next_preps = []
    @sequence=params[:song_sequence].to_i
    print(@sequence)
    @song = @list.songs[@sequence]
    print(@song)
    if @sequence < @list.songs.length - 1
      @next_song = @list.songs[@sequence+1]
      print(@next_song)
    end
    if @instrument_ids.present?
      @instrument_list = Instrument.where("id in (#{@instrument_ids.join(',')})").pluck(:name).join(', ')
      @preps = @song.preparations.where("instrument_id in (#{@instrument_ids.join(',')})")
      @next_preps = @next_song.preparations.where("instrument_id in (#{@instrument_ids.join(',')})") if @next_song.present?
    end
  end
end
