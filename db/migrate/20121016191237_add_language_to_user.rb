class AddLanguageToUser < ActiveRecord::Migration
  def up
    add_column :users, :language, :string, :limit => 2, :default => ""
    add_column :users, :email_notification, :boolean, :default => true, :null => false
    change_column :users, :is_admin, :boolean, :default => false, :null => false
    change_column :users, :firstname, :string, :limit => 30, :default => "", :null => false
    change_column :users, :lastname,  :string, :limit => 30, :default => "", :null => false

  end

  def down
    remove_column :users, :language
    remove_column :users, :email_notification
    change_column :users, :is_admin, :boolean, :default => false, :null => true
    change_column :users, :firstname, :string, :limit => 255, :default => nil, :null => false
    change_column :users, :lastname,  :string, :limit => 255, :default => nil, :null => false
  end
end
