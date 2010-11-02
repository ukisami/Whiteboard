class AddNameToLayers < ActiveRecord::Migration
  def self.up
    add_column :layers, :name, :string, :default => 'untitled', :null => 'untitled'
  end

  def self.down
    remove_column :layers, :name
  end
end
