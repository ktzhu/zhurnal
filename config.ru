require 'uri'
require 'sinatra/base'
require 'sinatra/reloader'
require 'mongoid'
require 'json'
require 'multi_json'
require 'coffee-script'
require 'sass'
require 'slim'
require 'instagram'
require 'twitter'
require './app'

run App
