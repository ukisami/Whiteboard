class Gallery < ActiveRecord::Base
	belongs_to :board	
	has_many :comments
	has_many :likes
	
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
	
	def updateRecValue
		if !self.likes
			self.recValue = self.totalView + 20*self.likes.count
		end
	end
	
end
