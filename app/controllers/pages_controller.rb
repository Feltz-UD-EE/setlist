class PagesController < ApplicationController
  # Manages uploading pages (image files) for songs
  def new
    @song_id = params[:song_id]
    @page = Page.new
  end

  def create
    @page = Page.new(page_params)
    respond_to do |format|
      if @page.save
        format.html { redirect_to @page.song, notice: "Page added." }
        format.json { render :show, status: :created, location: @page.song }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @page.update(page_params)
        format.html { redirect_to @page, notice: "Page was successfully updated." }
        format.json { render :show, status: :ok, location: @page }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_page
    @page = Page.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def page_params
    params.require(:page).permit(:sort_order, :song_id, :instrument_id, :img)
  end
end
