require 'rubygems'
require 'sinatra'
require 'mongoid'
require 'json'
require 'slim'

require File.join(File.dirname(__FILE__), '..', 'app.rb')

require 'rack/test'
require 'rspec'

Rspec.configure do |config|
  config.include Rack::Test::Methods

  def app
    App
  end
end
