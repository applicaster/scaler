class ServicesController < ApplicationController
  expose(:services) { Settings.services }

  def index
  end
end
