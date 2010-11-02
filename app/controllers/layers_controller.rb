class LayersController < ApplicationController
  # GET /layers
  # GET /layers.xml
  before_filter :get_board
  before_filter :require_token, :only => [:create, :destroy]

  def index
    if @board != nil
      @layers = @board.layers.all
    else
      @layers = Layer.all
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @layers }
    end
  end

  # GET /layers/1
  # GET /layers/1.xml
  # GET /layers/new
  # GET /layers/new.xml
  def new
    @layer = @board.layers.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @layer }
    end
  end

  # GET /layers/1/edit
  def edit
    @layer = @board.layers.find(params[:id])
  end

  # POST /layers
  # POST /layers.xml
  def create
    @layer = @board.layers.new(params[:layer])

    respond_to do |format|
      if @layer.save
        format.html { redirect_to(@board.owner_link, :notice => 'Layer was successfully created.') }
        format.xml  { render :xml => @layer, :status => :created, :location => @layer }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @layer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /layers/1
  # PUT /layers/1.xml
  def update
    @layer = @board.layers.find(params[:id])

    respond_to do |format|
      if @layer.update_attributes(params[:layer])
        format.html { redirect_to(@layer, :notice => 'Layer was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @layer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /layers/1
  # DELETE /layers/1.xml
  def destroy
    @layer = @board.layers.find(params[:id])
    @layer.destroy

    respond_to do |format|
      format.html { redirect_to(layers_url) }
      format.xml  { head :ok }
    end
  end

  def get_board
    begin
      @board = Board.find params[:board_id]
    rescue
      redirect_to root_path, :notice => "Board required"
    end
  end

  def require_token
    if params[:token] != @board.token
      redirect_to root_path, :notice => "Owner token required"
    end
  end
end
