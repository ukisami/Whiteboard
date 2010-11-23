class CommentsController < ApplicationController

	before_filter :get_gallery, :only => [:add_comment, :show_more]

  # GET /comments
  # GET /comments.xml
  def index
    @comments = Comment.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @comments }
    end
  end

  # GET /comments/1
  # GET /comments/1.xml
  def show
    @comment = Comment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @comment }
    end
  end

  # GET /comments/new
  # GET /comments/new.xml
  def new
    @comment = Comment.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @comment }
    end
  end

  # GET /comments/1/edit
  def edit
    @comment = Comment.find(params[:id])
  end

  # POST /comments
  # POST /comments.xml
  def create
    @comment = Comment.new(params[:comment])

    respond_to do |format|
      if @comment.save
        format.html { redirect_to(@comment, :notice => 'Comment was successfully created.') }
        format.xml  { render :xml => @comment, :status => :created, :location => @comment }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /comments/1
  # PUT /comments/1.xml
  def update
    @comment = Comment.find(params[:id])

    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        format.html { redirect_to(@comment, :notice => 'Comment was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.xml
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to(comments_url) }
      format.xml  { head :ok }
    end
  end

	def add_comment
    @comment = Comment.new(params[:comment])
		@comment.gallery = @gallery
    add_comment_id_string = 'add_comment_' + @gallery.id.to_s
		comment_content_string = 'comment_content_' + @gallery.id.to_s
    if @comment.save
        render :update do |page|
        	page.insert_html :before, add_comment_id_string, :partial => 'comments/comment', :locals => { :comment => @comment }
					page[comment_content_string].clear
        	page.replace_html 'comment_errors', :text => ''
        	page << "document.getElementById('#{add_comment_id_string}').getElementsByTagName('p')[0].className = 'inputRow'"
        end
     else 
        render :update do |page|
          page.replace_html 'comment_errors', :text => @comment.errors.on(:content)
          page << "document.getElementById('#{add_comment_id_string}').getElementsByTagName('p')[0].className = 'inputRow fieldWithErrors'"
        end
    end        
  end

	def show_more
    render :update do |page|
       page.replace_html 'comments_for_'+@gallery.id.to_s, :partial => @gallery.comments
    end
  end

	def get_gallery
    begin
      @gallery = Gallery.find params[:gallery_id]
    rescue
      redirect_to root_path, :notice => "Gallery required"
    end
  end

end
