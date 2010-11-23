class GalleriesController < ApplicationController

  protect_from_forgery :except => [:create]

  # GET /galleries
  # GET /galleries.xml
  def index
    @offset = params[:offset].to_i || 0
    @galleries = Gallery.all :offset => params[:offset], :limit => 6, :order => 'id DESC'

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @galleries }
    end
  end

  # GET /galleries/1
  # GET /galleries/1.xml
  def show
    @gallery = Gallery.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @gallery }
    end
  end

  # POST /galleries
  # POST /galleries.xml
  def create
		@board = Board.find(params[:board_id])
    if @board.permission(params[:token]) != :owner
      redirect_to root_path, :notice => 'Only board owner may publish.'
      return
    end
    @gallery = @board.galleries.create(
      :composite => params[:composite],
      :thumbnail => params[:thumbnail],
      :revision => params[:revision]
    )

    respond_to do |format|
      if @gallery.save
        format.html { head :ok }
        format.xml  { render :xml => @gallery, :status => :created, :location => @gallery }
      else
        format.html { redirect_to '/' }
        format.xml  { render :xml => @gallery.errors, :status => :unprocessable_entity }
      end
    end
  end

end
