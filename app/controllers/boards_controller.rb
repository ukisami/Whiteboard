class BoardsController < ApplicationController

  # GET /boards
  # GET /boards.xml
  def index
    @boards = Board.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @boards }
    end
  end

  # GET /boards/1
  # GET /boards/1.xml
  def show
    @board = Board.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @board }
    end
  end

  # GET /boards/new
  # GET /boards/new.xml
  def new
    @board = Board.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @board }
    end
  end

  # GET /boards/1/edit
  def edit
    @board = Board.find(params[:id])
  end

  # POST /boards
  # POST /boards.xml
  def create
    @board = Board.new(params[:board])

    respond_to do |format|
      if @board.save
        format.html { redirect_to(@board.owner_link, :notice => 'Your WhiteBoard was successfully created.') }
        format.xml  { render :xml => @board, :status => :created, :location => @board }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @board.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /boards/1
  # PUT /boards/1.xml
  def update
    @board = Board.find(params[:id])

    respond_to do |format|
      if @board.update_attributes(params[:board])
        format.html { redirect_to(@board, :notice => 'Your WhiteBoard was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @board.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /boards/1
  # DELETE /boards/1.xml
  def destroy
    @board = Board.find(params[:id])
    @board.destroy

    respond_to do |format|
      format.html { redirect_to(boards_url) }
      format.xml  { head :ok }
    end
  end

  def publish
    require 'base64'
    @board = Board.find(params[:id])
    if @board.permission(params[:token]) == :owner
      composite = params[:composite]
      thumbnail = params[:thumbnail]
      revision = params[:revision]
      @board.galleries.create(:revision=>revision, :thumbnail=>thumbnail, :composite=>composite)
    else
      redirect_to root_path, :notice => "Owner token required"
    end
  end

  def poll
    if params[:revision] && (revision = params[:revision].to_i) != 0
      @board = Board.find(params[:id])
      updates = @board.table_of_updates_since_revision(revision)
      respond_to do |format|
        format.html {render :text => updates.to_json.to_s}
        format.json {render :json => updates.to_json}
      end
    else
      respond_to do |format|
        format.html {render :text => "Invalid Revision"}
      end
    end
  end

end
