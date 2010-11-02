class Layer < ActiveRecord::Base
  belongs_to :board
  before_create :randomized_token 


  def randomized_token
    self.token = ActiveSupport::SecureRandom.hex(16)
  end


end
