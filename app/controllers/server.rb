require 'sinatra/base'
require 'bundler/setup'
require 'sinatra/reloader' if Sinatra::Base.environment == :development
require 'logger'
require "sinatra/activerecord"

require_relative '../models/init'

class App < Sinatra::Application

  configure :production, :development do
    enable :logging
    logger = Logger.new(STDOUT)
    logger.level = Logger::DEBUG if development?
    set :logger, logger
  end
  
  configure :development do
    register Sinatra::Reloader
    after_reload do
      puts 'Reloaded...'
    end
  end

  configure do 
    set :views, 'app/views'
    set :public_folder, 'public'
  end

  def initialize(app = nil)
    super()
  end

  user = [
    {name: 'Juan', email: 'juan@gmail.com',password:'12345'},
    {name: 'Pedro', email: 'pedro@gmail.com',password:'12345'},
    {name: 'Ana', email: 'ana@gmail.com',password:'12345'}
  ]


  get '/users2/:name' do
    user.find { |u| u[:name] == params[:name] }.to_s
  end

  #post
  post '/users' do
    user.push(params)
    user.to_json
  end

  get '/users' do
    erb:user
  end 

  get '/' do
    logger.info(Player.all)
    
  end

end