class Server < ActiveRecord::Base
  extend FriendlyId

  friendly_id :name, :use => :slugged

  serialize :preferences, OpenStruct

  has_many :monitorings
  has_many :incidents

  attr_accessible :host, :name, :slug, :is_public, :status, :synchronized_at,
                  :preferences

  # Named Scopes
  scope :publics, lambda{ where("is_public = ?", true) }

  # Validators
  validates_uniqueness_of :name, :host
  validates_presence_of   :name, :host
  validate                :domain_exists?


  # Lock friendly_id generation if this record is not a new record
  def should_generate_new_friendly_id?
    new_record?
  end

  def slug=(new_slug)
    super if should_generate_new_friendly_id?
  end


  # Job methods
  def uptime(started=nil, ended=nil)
    100.0 - downtime = downtime(started, ended)
  end

  def downtime(started=nil, ended=nil)
    downtime = 0.0
    prev     = nil
    now      = Time.current
    started  = now - 1.month if started.nil?
    ended    = now if ended.nil?

    monitorings = self.monitorings.where("protocol = ? AND (? <= created_at AND created_at <= ?)", 'ping', started, ended)
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
      downtime += now - prev.created_at
    end

    total_time = ended - started
    (downtime / total_time) * 100.0
  end

private
  def domain_exists?
    w = Whois::Client.new(:timeout => 10)
    # r = w.query(self.host)

    # errors.add(:host, "server_form.host_invalid") unless r.registered?
  # rescue Whois::Error => e
  #   errors.add(:host, "server_form.host_not_found")
  end
end
