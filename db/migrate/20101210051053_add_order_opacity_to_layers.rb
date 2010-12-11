class AddOrderOpacityToLayers < ActiveRecord::Migration
  def self.up
    add_column :layers, :order, :integer
    add_column :layers, :opacity, :integer, :default => 100
    add_column :layers, :visible, :boolean, :default => true
    add_column :layers, :last_order_update, :datetime
    add_column :layers, :order_update, :boolean, :default => false
    add_column :layers, :last_opacity_update, :datetime
    add_column :layers, :opacity_update, :boolean, :default => false
    add_column :layers, :last_visible_update, :datetime
    add_column :layers, :visible_update, :boolean, :default => false
    add_column :layers, :last_data_update, :datetime
    add_column :layers, :data_update, :boolean, :default => false
  end

  def self.down
    remove_column :layers, :data_update, :boolean
    remove_column :layers, :last_data_update
    remove_column :layers, :visible_update, :boolean
    remove_column :layers, :last_visible_update
    remove_column :layers, :opacity_update, :boolean
    remove_column :layers, :last_opacity_update
    remove_column :layers, :order_update, :boolean
    remove_column :layers, :last_order_update
    remove_column :layers, :visible, :boolean
    remove_column :layers, :opacity
    remove_column :layers, :order
  end
end
