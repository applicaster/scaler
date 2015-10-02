require 'active_support/core_ext/time/zones'
require 'sinatra_more/markup_plugin'
require 'sinatra_more/render_plugin'
require './lib/helpers'
require './models/launch_configuration'
require './models/group'
require './models/scheduled_action'
register SinatraMore::MarkupPlugin
register SinatraMore::RenderPlugin
use Rack::MethodOverride
set :server, 'thin'
set :root, File.dirname(__FILE__)
use Rack::Auth::Basic do |username, password|
  username == ENV['SCALER_USER'] && password == ENV['SCALER_PASS']
end

AWS.config({
  access_key_id: ENV['AWS_ACCESS_KEY_ID'],
  secret_access_key:ENV['AWS_SECRET_ACCESS_KEY'],
  logger: Logger.new($stdout),
})

AS = AWS::AutoScaling.new
EC2 = AWS::EC2.new
ELB = AWS::ELB.new

before { Time.zone = ENV['SCALER_TZ'] }

get '/' do
 haml :index 
end

get '/groups' do
  haml :"groups/index"
end

get '/groups/new' do
  @group = Group.new
  haml :"groups/new"
end

post '/groups' do
  @group = Group.new(params[:group])
  if @group.save
    redirect to('/groups')
  else
    haml :"groups/new"
  end
end

get '/groups/:name/edit' do |name|
  @group = Group.find(name)
  haml :"groups/edit"
end

put '/groups' do
  @group = Group.new(params[:group])
  if @group.save
    redirect to('/groups')
  else
    haml :"groups/edit"
  end
end

delete '/groups/:name' do |name|
  @group = Group.find(name)
  @group.destroy if @group
  204
end

get '/launch_configurations' do
  haml :"launch_configurations/index"
end

get '/launch_configurations/new' do
  @launch_configuration = LaunchConfiguration.new
  haml :"launch_configurations/new"
end

post '/launch_configurations' do
  @launch_configuration = LaunchConfiguration.new(params[:launch_configuration])
  if @launch_configuration.save
    redirect to('/launch_configurations')
  else
    haml :"launch_configurations/new"
  end
end

delete '/launch_configurations/:name' do |name|
  @launch_configuration = LaunchConfiguration.find(name)
  @launch_configuration.destroy if @launch_configuration
  204
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
