require 'active_support/core_ext/time/zones'
require 'sinatra_more/markup_plugin'
require 'sinatra_more/render_plugin'
require './lib/helpers'
require './models/group'
require './models/scheduled_action'
register SinatraMore::MarkupPlugin
register SinatraMore::RenderPlugin
use Rack::MethodOverride
set :server, 'puma'
set :root, File.dirname(__FILE__)
use Rack::Auth::Basic do |username, password|
  username == ENV['SCALER_USER'] && password == ENV['SCALER_PASS']
end

AWS.config({
  access_key_id: ENV['AWS_ACCESS_KEY_ID'],
  secret_access_key:ENV['AWS_SECRET_ACCESS_KEY'],
  logger: Logger.new($stdout),
})

before { Time.zone = ENV['SCALER_TZ'] }

get '/' do
 haml :index 
end

get '/groups' do
  haml :"groups/index"
end

get '/scheduled_actions' do
  haml :"scheduled_actions/index"
end

get '/scheduled_actions/new' do
  @scheduled_action = ScheduledAction.new
  haml :"scheduled_actions/new"
end

post '/scheduled_actions' do
  @scheduled_action = ScheduledAction.new(params[:scheduled_action])
  if @scheduled_action.save
    redirect to('/scheduled_actions')
  else
    haml :"scheduled_actions/new"
  end
end

get '/scheduled_actions/:name/edit' do |name|
  @scheduled_action = ScheduledAction.find(name)
  haml :"scheduled_actions/edit"
end

put '/scheduled_actions' do
  @scheduled_action = ScheduledAction.new(params[:scheduled_action])
  if @scheduled_action.save
    redirect to('/scheduled_actions')
  else
    haml :"scheduled_actions/edit"
  end
end

delete '/scheduled_actions/:name' do |name|
  @scheduled_action = ScheduledAction.find(name)
  @scheduled_action.destroy if @scheduled_action
  204
end
