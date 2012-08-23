class UpdateServerStatus < ActiveRecord::Migration
  def up
    change_column(:servers, :status, :integer, { :limit => 1, :null => false, :default => true })
  end

  def down
    change_column(:servers, :status, :integer, { :limit => 1, :null => false, :default => true })
  end
end
