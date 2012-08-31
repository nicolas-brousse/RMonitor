class CreateIncidents < ActiveRecord::Migration
  def change
    create_table :incidents do |t|
      t.string :name
      t.text :body
      t.references :monitoring
      t.references :server

      t.timestamps
    end
    add_index :incidents, :monitoring_id
    add_index :incidents, :server_id
  end
end
