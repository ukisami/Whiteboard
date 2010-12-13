class AddLastSortToGallery < ActiveRecord::Migration
  def self.up
    add_column :galleries, :lastSort, :string
  end

  def self.down
    remove_column :galleries, :lastSort
  end
end
