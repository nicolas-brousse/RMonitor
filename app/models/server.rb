class Server < ActiveRecord::Base
  extend FriendlyId

  friendly_id :name, :use => :slugged

  has_many :monitorings

  attr_accessible :host, :name, :status, :synchronized_at

  # Named Scopes
  scope :publics, lambda{ where('true') } #where("is_public = ?", true) }


  # Lock friendly_id generation if this record is not a new record
  def should_generate_new_friendly_id?
    new_record?
  end


  # Job methods
  def uptime(started=nil, ended=nil)
    100.0 - downtime = downtime(started, ended)
  end

  def downtime(started=nil, ended=nil)
    downtime = 0.0
    prev     = nil
    started  = Time.now - 1.month if started.nil?
    ended    = Time.now if ended.nil?

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
