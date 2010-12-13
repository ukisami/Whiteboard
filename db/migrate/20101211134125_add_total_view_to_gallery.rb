class AddTotalViewToGallery < ActiveRecord::Migration
  def self.up
    add_column :galleries, :totalView, :integer
  end

  def self.down
    remove_column :galleries, :totalView
  end
end
