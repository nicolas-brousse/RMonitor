class Incident < ActiveRecord::Base
  belongs_to :monitoring
  belongs_to :server

  # https://github.com/collectiveidea/audited
  # audited

  attr_accessible :body, :name
end
