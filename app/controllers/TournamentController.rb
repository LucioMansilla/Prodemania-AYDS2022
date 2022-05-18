require 'sinatra/reloader' if Sinatra::Base.environment == :development
require 'logger'
require_relative '../models/tournament'
require 'sinatra/activerecord'