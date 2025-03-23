class PagesController < ApplicationController
  # Manages uploading pages (image files) for songs
  def new

  end

  def create

    redirect_to controller: 'song', action: 'show', song_id: song.id
  end

  def edit

  end

  def update

  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_page
    @page = Page.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def page_params
    params.require(:page).permit()
  end
end
