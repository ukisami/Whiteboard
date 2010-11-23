class Gallery < ActiveRecord::Base
	belongs_to :board	
	has_many :comments
	
	def title
		board.title
	end
	
end
