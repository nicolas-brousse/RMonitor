class UpdateServerStatus < ActiveRecord::Migration
  def up
    change_column(:servers, :status, :integer, { :limit => 1, :null => false, :default => 0 })
  end

  def down
    change_column(:servers, :status, :boolean)
  end
end
