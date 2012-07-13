class Server < ActiveRecord::Base
  has_many :monitorings

  attr_accessible :host, :name, :status, :synchronized_at

  # Named Scopes
  scope :publics, lambda{ where('true') } #where("is_public = ?", true) }

  def uptime
    out_time = 0
    latest = nil

    monitorings = self.monitorings
    return null if monitorings.nil?

    monitorings.order('created_at ASC').each do |m|
      if !latest.nil? && latest.status != m.status
        out_time += m.created_at - latest.created_at
      end
      latest = m
    end

    if !latest.status
      out_time += Time.now - latest.created_at
    end

    total_time = Time.now - (self.monitorings.order('created_at DESC').last).created_at
    100 - ((total_time - out_time) / total_time)
  end
end
