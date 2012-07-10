class Server < ActiveRecord::Base
  attr_accessible :host, :name, :status, :synchronized_at

  # Named Scopes
  scope :publics, lambda{ order("name ASC") } #where("is_public = ?", true) }
end
