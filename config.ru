require 'rubygems'
require 'bundler'
Bundler.setup

require "./config/environment"
run ActionController::Dispatcher.new