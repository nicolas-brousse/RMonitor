class Incident < ActiveRecord::Base
  belongs_to :monitoring
  belongs_to :server

  attr_accessible :body, :name
end
