class Incident < ActiveRecord::Base
  belongs_to :monitoring
  belongs_to :server

  # https://github.com/collectiveidea/audited
  # audited

  attr_accessible :body, :name, :monitoring_id

  # Validators
  validates_presence_of   :name, :body
end
