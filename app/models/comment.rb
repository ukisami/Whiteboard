class Comment < ActiveRecord::Base
  belongs_to :gallery
  belongs_to :reply_to, :class_name => "Comment", :foreign_key => "comment_id"
  #belongs_to :, :class_name => "User", :foreign_key => "user_id"
end
