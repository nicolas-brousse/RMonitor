class AddOptionsOnServersTable < ActiveRecord::Migration
  def up
    change_table :servers do |t|
      t.boolean  :is_public
      t.string   :slug
    end

    add_index :servers, :slug, :unique => true

    Server.find_each(&:save)
  end

  def down
    remove_index :servers, :slug

    change_table :servers do |t|
      t.remove  :is_public, :slug
    end
  end
end
