class AddServerPreferences < ActiveRecord::Migration
  def up
    change_table :servers do |t|
      t.text :preferences
    end
  end

  def down
    change_table :servers do |t|
      t.remove  :preferences
    end
  end
end
