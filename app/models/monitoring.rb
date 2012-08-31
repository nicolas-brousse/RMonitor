class Monitoring < ActiveRecord::Base
  belongs_to :server
  has_many :incidents

  attr_accessible :created_at, :protocol, :status

  before_create :before_create

  DOWN = false
  UP   = true

private
  def before_create
    self.created_at = Time.current
  end
end
