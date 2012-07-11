class Api::IndexController < ApplicationController
  respond_to :json

  def index
    json = []
    Server.publics.each do |s|
      json.push({
        :name   => s.name,
        :host   => s.host,
        :status => s.status ? :green : :red,
      })
    end
    respond_with(json)
  end

end
