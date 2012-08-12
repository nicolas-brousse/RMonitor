class UserPreference < ActiveRecord::Base
  belongs_to :user

  attr_accessible :time_zone
end
