class AddDataToLayers < ActiveRecord::Migration
  def self.up
    add_column :layers, :data, :text, :limit => 2**24
  end

  def self.down
    remove_column :layers, :data
  end
end
