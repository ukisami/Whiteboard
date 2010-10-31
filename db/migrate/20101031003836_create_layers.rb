class CreateLayers < ActiveRecord::Migration
  def self.up
    create_table :layers do |t|
      t.references :board
      t.string :token
      t.integer :order

      t.timestamps
    end
  end

  def self.down
    drop_table :layers
  end
end
