class CreateGalleries < ActiveRecord::Migration
  def self.up
    create_table :galleries do |t|
      t.int :boardid
      t.int :revision
      t.text :composite, :limit=>2**24
      t.text :thumbnail

      t.timestamps
    end
  end

  def self.down
    drop_table :galleries
  end
end
