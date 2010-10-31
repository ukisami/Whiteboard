class LayersController < ApplicationController
  # GET /layers
  # GET /layers.xml
  def index
    @layers = Layer.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @layers }
    end
  end

  # GET /layers/1
  # GET /layers/1.xml
  def show
    @layer = Layer.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @layer }
    end
  end

  # GET /layers/new
  # GET /layers/new.xml
  def new
    @layer = Layer.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @layer }
    end
  end

  # GET /layers/1/edit
  def edit
    @layer = Layer.find(params[:id])
  end

  # POST /layers
  # POST /layers.xml
  def create
    @layer = Layer.new(params[:layer])

    respond_to do |format|
      if @layer.save
        format.html { redirect_to(@layer, :notice => 'Layer was successfully created.') }
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
    @layer = Layer.find(params[:id])

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
    @layer = Layer.find(params[:id])
    @layer.destroy

    respond_to do |format|
      format.html { redirect_to(layers_url) }
      format.xml  { head :ok }
    end
  end
end
