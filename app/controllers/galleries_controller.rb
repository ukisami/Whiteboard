class GalleriesController < ApplicationController

  protect_from_forgery :except => [:create]

  # GET /galleries
  # GET /galleries.xml
  def index
  	@galleries = Gallery.find(:all)
  	@galleries.each do |gallery|
  		gallery.updateRecValue
  		gallery.save
  	end
    @offset = params[:offset].to_i || 0
    @sort = params[:sort].to_s
    if @sort==""
    	@sort = "byDate"
    end
    if @sort != "byDate"
			if @sort=='byViews'
				@galleries = Gallery.all :offset => params[:offset], :limit => 6, :order => 'totalView DESC'
			elsif @sort == 'byRec'
				@galleries = Gallery.all :offset => params[:offset], :limit => 6, :order => 'recValue DESC'
			else
				@galleries = Gallery.all :offset => params[:offset], :limit => 6, :order => 'created_at DESC'
			end
		else
			@galleries = Gallery.all :offset => params[:offset], :limit => 6, :order => 'id DESC'
		end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @galleries }
    end
  end

	
  # GET /galleries/1
  # GET /galleries/1.xml
  def show
  	@offset = params[:offset].to_i || 0
  	@sort = params[:sort].to_s
    @gallery = Gallery.find(params[:id])
   	@gallery.incOne
   	@gallery.updateRecValue
   	@gallery.save

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
      :revision => params[:revision],
      :totalView => 0,
      :recValue => 0
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

  def search
		@boards = Board.search(params[:search])
		@galleries = []
		@boards.each do |board|
			@galleries.concat(board.galleries)
		end
		@galleres = @galleries.uniq
		@offset = params[:offset].to_i || 0
		@sort = params[:sort].to_s
		@hide = true
		render :action => "index"
	end

end
