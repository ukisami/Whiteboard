class Publication < ActiveRecord::Base
  belongs_to :board
  has_many :comments
end
