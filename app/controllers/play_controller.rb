require "base64"
require "marcel"

class PlayController < ApplicationController
  # Select a list to play through (w/ 0-n instruments): renders the #play action after submitting fo
  def choose
    if params[:list_id].present?
      @list_id = params[:list_id]
      list = List.find(params[:list_id])
      authorize_band!(list.band)
      @list_name = list.name
    else
      @lists =  List.where(band_id: accessible_bands.select(:id)).alpha
    end
    @instruments = Instrument.all.alpha
    @display_types = [["Song by Song"], ["One Screen"]]
  end

  # POST from non-model form in #start
  # Just processes instrument_ids and redirects to #play
  def cue
    list = List.find(params[:list_id])
    authorize_band!(list.band)
    instrument_ids = selected_instrument_ids
    if params[:download_setlist].present?
      redirect_to controller: 'play', action: 'download', list_id: list.id, instrument_ids: instrument_ids
      return
    end
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
    authorize_band!(@list.band)
    @instrument_ids = selected_instrument_ids
    @preps = []
    @song = @list.songs.first
    if @instrument_ids.present?
      @instrument_list = Instrument.where(id: @instrument_ids).pluck(:name).join(', ')
      @preps = @song.preparations.where(instrument_id: @instrument_ids)
    end
  end

  # Shows an individual song, including prep & intro for the following song
  # TODO check for off-by-one errors
  # TODO figure out paradigm for no instruments vs some instruments vs all instruments
  # TODO refactor instrument & prep stuff into model methods
  def play_song
    @list = List.find(params[:list_id])
    authorize_band!(@list.band)
    @instrument_ids = selected_instrument_ids
    @preps = []
    @next_preps = []
    @sequence=params[:song_sequence].to_i
    @song = @list.songs[@sequence]
    if @sequence < @list.songs.length - 1
      @next_song = @list.songs[@sequence+1]
    end
    if @instrument_ids.present?
      @instrument_list = Instrument.where(id: @instrument_ids).pluck(:name).join(', ')
      @preps = @song.preparations.where(instrument_id: @instrument_ids)
      @next_preps = @next_song.preparations.where(instrument_id: @instrument_ids) if @next_song.present?
    end
    @sheets = @song.sheets_for_instruments(@instrument_ids)
  end

# Shows entire setlist on one page, suggested by Chip.
# TODO: restructure the return data into a big JSON instead of 3 arrays?
  def play_all
    prepare_one_screen_setlist
  end

  def download
    prepare_one_screen_setlist(embed_sheets: true)
    html = render_to_string(:download, layout: false, formats: [:html])
    send_data html,
      filename: "#{@list.name.parameterize}-offline-#{@list.updated_at.strftime('%Y%m%d')}.html",
      type: "text/html",
      disposition: "attachment"
  end

  private

  def selected_instrument_ids
    Array(params[:instrument_ids]).reject(&:blank?).map(&:to_i)
  end

  def prepare_one_screen_setlist(embed_sheets: false)
    @list = List.find(params[:list_id])
    authorize_band!(@list.band)
    @instrument_ids = selected_instrument_ids
    @songs = @list.songs
    @preps = []
    @sheets = []
    if @instrument_ids.present?
      @instrument_list = Instrument.where(id: @instrument_ids).pluck(:name).join(', ')
      @songs.each do |song|
        preps = song.preparations.where(instrument_id: @instrument_ids)
        @preps << preps
      end
    else
      @songs.each { @preps << [] }
    end
    @songs.each { |song| @sheets << song.sheets_for_instruments(@instrument_ids) }
    @embedded_sheet_images = embed_sheets ? embedded_sheet_images : {}
  end

  def embedded_sheet_images
    @sheets.flatten.index_with { |sheet| data_uri_for(sheet) }
  end

  def data_uri_for(sheet)
    return if sheet.img.blank? || sheet.img.path.blank? || !File.exist?(sheet.img.path)

    mime_type = Marcel::MimeType.for(Pathname.new(sheet.img.path))
    "data:#{mime_type};base64,#{Base64.strict_encode64(File.binread(sheet.img.path))}"
  end
end
