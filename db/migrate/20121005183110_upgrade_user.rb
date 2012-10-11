class UpgradeUser < ActiveRecord::Migration
  def up
    add_column :users, :firstname, :string
    add_column :users, :lastname, :string
    add_column :users, :is_admin, :boolean, {:default => false}

    User.new({:email => "admin@rmonitor.com", :password => "password"}).save(:validate => false)

    say_with_time "Upgrade User #1 to admin" do
      u = User.find(1)
      u.is_admin  = true
      u.firstname = "Admin"
      u.lastname  = "Admin"
      u.save!
    end
  end

  def down
    remove_column :users, :firstname
    remove_column :users, :lastname
    remove_column :users, :is_admin
  end
end
