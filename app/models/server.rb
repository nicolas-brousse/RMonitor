class Server < ActiveRecord::Base
  has_many :monitorings

  attr_accessible :host, :name, :status, :synchronized_at

  # Named Scopes
  scope :publics, lambda{ where('true') } #where("is_public = ?", true) }

  def uptime(start=nil)
    downtime = 0
    latest = nil
    start = Time.now.at_beginning_of_month if start.nil?

    monitorings = self.monitorings.where("protocol = 'Ping' AND created_at >= ?", start)
    return null if monitorings.nil?

    monitorings.order('created_at ASC').each do |m|
      if !latest.nil? && m.status == false
        downtime += m.created_at - latest.created_at
      end
      latest = m
    end

    if !latest.nil? && !latest.status
      downtime += Time.now - latest.created_at
    end

    total_time = Time.now - start
    100 - ((downtime / total_time) * 100)
  end
end
