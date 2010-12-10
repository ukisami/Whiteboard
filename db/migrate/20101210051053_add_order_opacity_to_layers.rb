class AddOrderOpacityToLayers < ActiveRecord::Migration
  def self.up
    add_column :layers, :layerid, :integer
    add_column :layers, :opacity, :integer
    add_column :layers, :visible, :boolean
    add_column :layers, :last_layerid_update, :datetime
    add_column :layers, :layerid_update, :boolean
    add_column :layers, :last_opacity_update, :datetime
    add_column :layers, :opacity_update, :boolean
    add_column :layers, :last_visible_update, :datetime
    add_column :layers, :visible_update, :boolean
    add_column :layers, :last_data_update, :datetime
    add_column :layers, :data_update, :boolean
  end

  def self.down
    remove_column :layers, :data_update, :boolean
    remove_column :layers, :last_data_update
    remove_column :layers, :visible_update, :boolean
    remove_column :layers, :last_visible_update
    remove_column :layers, :opacity_update, :boolean
    remove_column :layers, :last_opacity_update
    remove_column :layers, :layerid_update, :boolean
    remove_column :layers, :last_layerid_update
    remove_column :layers, :visible, :boolean
    remove_column :layers, :opacity
    remove_column :layers, :layerid
  end
end
