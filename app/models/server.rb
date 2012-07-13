class Server < ActiveRecord::Base
  has_many :monitorings

  attr_accessible :host, :name, :status, :synchronized_at

  # Named Scopes
  scope :publics, lambda{ where('true') } #where("is_public = ?", true) }

  def uptime(started=nil, ended=nil)
    100.0 - downtime = downtime(started, ended)
  end

  def downtime(started=nil, ended=nil)
    downtime = 0.0
    prev     = nil
    started  = Time.now.at_beginning_of_month if started.nil?
    ended    = Time.now.at_end_of_month if ended.nil?

    monitorings = self.monitorings.where("protocol = ? AND (? <= created_at AND created_at <= ?)", 'Ping', started, ended)
                                  .order('created_at ASC')

    return downtime if monitorings.empty?

    monitorings.each do |m|
      if m.status == Monitoring::UP
        if m == monitorings.first
          downtime += monitorings.first.created_at - started
        elsif !prev.nil? && prev.status == Monitoring::DOWN
          downtime += m.created_at - prev.created_at
        end
      end
      prev = m
    end

    if !prev.nil? && prev.status == Monitoring::DOWN
      downtime += Time.now - prev.created_at
    end

    total_time = ended - started
    (downtime / total_time) * 100.0
  end

end
