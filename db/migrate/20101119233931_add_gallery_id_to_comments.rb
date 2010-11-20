class AddGalleryIdToComments < ActiveRecord::Migration
  def self.up
    add_column :comments, :gallery_id, :integer
	remove_column :comments, :publication_id
  end
 
  def self.down
    remove_column :comments, :gallery_id
	add_column :comments, :publication_id, :integer
  end
end
