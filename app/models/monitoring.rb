class Monitoring < ActiveRecord::Base
  belongs_to :server
  has_many :incidents

  attr_accessible :created_at, :protocol, :status

  before_create :before_create

  validates_presence_of   :protocol
  validates_presence_of   :server
  validate                :protocol_exists?

  DOWN = false
  UP   = true

private
  def protocol_exists?
    errors.add(:host, "monitoring_form.protocol_does_not_exists") unless RMonitor::Modules::Monitorings.protocol_exists? self.protocol
  end

  def before_create
    self.status ||= Monitoring::DOWN
    self.created_at = Time.current
  end
end
