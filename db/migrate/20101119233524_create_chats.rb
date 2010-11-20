class CreateChats < ActiveRecord::Migration
  def self.up
    create_table :chats do |t|
      t.string :author
      t.string :body
      t.references :board

      t.timestamps
    end
  end

  def self.down
    drop_table :chats
  end
end
