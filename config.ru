require 'uri'
require 'sinatra/base'
require 'sinatra/reloader'
require 'mongoid'
require 'json'
require 'coffee-script'
require 'sass'
require 'slim'
require 'instagram'
require './app'

run App
