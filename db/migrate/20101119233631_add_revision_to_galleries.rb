class AddRevisionToGalleries < ActiveRecord::Migration
  def self.up
    add_column :galleries, :revision, :integer, :unsigned => true
  end
 
  def self.down
    remove_column :galleries, :revision
  end
end
