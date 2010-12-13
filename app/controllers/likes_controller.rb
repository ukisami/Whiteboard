class LikesController < ApplicationController
	
	def create
		@gallery = Gallery.find(params[:gallery])
		@like = @gallery.likes.new()
		@like.ip = request.remote_ip
		if @like.save
        render :update do |page|
        	page.replace_html 'like', :partial => 'likes/like', :locals => { :like_count => @gallery.likes.count }
        	page.replace_html 'like_errors', :text => ''
        end
     else 
        render :update do |page|
          page.replace_html 'like_errors', :text => @like.errors.on(:content)
        end
    end 
	end

end
