class CreateServers < ActiveRecord::Migration
  def change
    create_table :servers do |t|
      t.string      :name
      t.string      :host
      t.boolean     :status
      t.datetime    :synchronized_at

      t.timestamps
    end
  end
end
