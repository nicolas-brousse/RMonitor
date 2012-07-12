class CreateMonitorings < ActiveRecord::Migration
  def change
    create_table :monitorings do |t|
      t.references :server
      t.string :protocol
      t.boolean :status
      t.datetime :created_at
    end
    add_index :monitorings, :server_id
  end
end
