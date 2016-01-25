class ServicesController < ApplicationController
  expose(:services) { Service.all }

  def index
  end
end
