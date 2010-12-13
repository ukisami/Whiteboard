class CreateLikes < ActiveRecord::Migration
  def self.up
    create_table :likes do |t|
      t.string :ip
      t.references :gallery

      t.timestamps
    end
  end

  def self.down
    drop_table :likes
  end
end
