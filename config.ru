require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)

require File.expand_path '../scaler.rb', __FILE__
run Sinatra::Application
