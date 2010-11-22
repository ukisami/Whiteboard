class AddBoardIdToGalleries < ActiveRecord::Migration
  def self.up
    add_column :galleries, :board_id, :integer
  end
 
  def self.down
    remove_column :galleries, :board_id
  end
end
