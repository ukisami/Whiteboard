class GalleriesController < ApplicationController

  protect_from_forgery :except => [:create]

  # GET /galleries
  # GET /galleries.xml
  def index
    @offset = params[:offset].to_i || 0
    @latest = Gallery.find(:all)
    @mostRecentSort = @latest.last.lastSort
    @sort = params[:sort].to_s
    if @sort==""
    	@sort = @mostRecentSort
    	if @offset==0
    		@sort= "byDate"
    	end
    end
    if @sort != "byDate"
    	@latest.last.lastSort = @sort
			if @sort=='byViews'
				@galleries = Gallery.all :offset => params[:offset], :limit => 6, :order => 'totalView DESC'
			elsif @sort == 'byRec'
				@galleries = Gallery.all :offset => params[:offset], :limit => 6, :order => 'id DESC'
			else
				@galleries = Gallery.all :offset => params[:offset], :limit => 6, :order => 'id DESC'
			end
		else
			@latest.last.lastSort = @sort
			@galleries = Gallery.all :offset => params[:offset], :limit => 6, :order => 'created_at DESC'
		end
		@latest.last.save

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @galleries }
    end
  end

	
  # GET /galleries/1
  # GET /galleries/1.xml
  def show
  	@offset = params[:offset].to_i || 0
    @gallery = Gallery.find(params[:id])
   	@gallery.incOne
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
      :lastSort => "byDate"
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
		render :action => "index"
	end

end
