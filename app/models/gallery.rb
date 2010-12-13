class Gallery < ActiveRecord::Base
	belongs_to :board	
	has_many :comments
	
	def title
		board.title
	end
	
	def incOne
		if self.totalView
			self.totalView += 1
		else
			self.totalView = 1
		end
	end
	
end
