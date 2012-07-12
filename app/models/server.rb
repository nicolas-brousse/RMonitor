class Server < ActiveRecord::Base
  has_many :monitorings

  attr_accessible :host, :name, :status, :synchronized_at

  # Named Scopes
  scope :publics, lambda{ where('true') } #where("is_public = ?", true) }
end
