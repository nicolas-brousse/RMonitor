class Monitoring < ActiveRecord::Base
  belongs_to :server
  attr_accessible :created_at, :protocol, :status

  before_create :before_create

private
  def before_create
    self.created_at = Time.now
  end
end
