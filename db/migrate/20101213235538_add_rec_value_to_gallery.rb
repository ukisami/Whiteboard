class AddRecValueToGallery < ActiveRecord::Migration
  def self.up
    add_column :galleries, :recValue, :integer
  end

  def self.down
    remove_column :galleries, :recValue
  end
end
