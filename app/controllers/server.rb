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
    set :sessions, true
    set :session_secret, ENV.fetch('SESSION_SECRET') { SecureRandom.hex(64) }
  end

  def initialize(app = nil)
    super()
  end

  ##---Player Controller ---##
  get '/signup' do
    erb :"players/signup"
  end

  post '/signup' do
    player = Player.new(params)
    
    if !player.save  
      redirect '/signup'
    else
      redirect '/login'
    end
  end

  get '/login' do
    erb :"players/login"
  end

  post '/login' do
    player = Player.find_by_name(params[:name])

    if player && player.authenticate(params[:password])
      session[:player_id] = player.id 
      redirect '/inicio'
    else
      redirect '/login'
    end
  end

  get '/logout' do
    session.clear
    redirect '/login'
  end

  get '/inicio' do 
    erb :inicio
  end

  get '/jugar' do 
    @tournaments = Tournament.all 
    erb :"jugar/tournaments_jugar"
  end

  get '/points' do
    @tournaments = Tournament.all 
    erb :"points/tournament_points"
  end

  get '/points/:tournament_id' do
    @points = Point.where(tournament_id: params[:tournament_id]) 
    erb :"points/points"
  end

  before do
    if session[:player_id]
      @current_player = Player.find_by(id: session[:player_id])
    else
      public_pages = ["/login", "/signup"]
      if !public_pages.include?(request.path_info)
        redirect '/login'
      end
    end
  end

  ## ----forecasts controller----- ##
  post '/forecast' do
    forecast = Forecast.new
    forecast.match_id = params['match_id']
    forecast.player_id = params['player_id']
    forecast.result = params['result']
    forecast.home_goals = params['home_goals']
    forecast.away_goals = params['away_goals']
    forecast.tournament_id = params['tournament_id']
    if(!forecast.check_match_player && forecast.resultConsist) then
        forecast.save
    else
        status 400
        {:status => 400, :mge => "There is already a prediction for that match"}.to_json
    end
end

put '/forecast/:id' do
    forecast = Forecast.find_by(id: params['id'])
    if(forecast) then
        forecast.result = params['result']
        forecast.home_goals = params['home_goals']
        forecast.away_goals = params['away_goals']
        forecast.tournament_id = params['tournament_id']
        if(!forecast.check_match_player && forecast.resultConsist) then
            forecast.points = 0
            forecast.save
        else
            status 400
            {:status => 400, :mge => "There is already a prediction for that match"}.to_json
        end
    else
        status 400
        {:status => 404, :mge => "This forecast doesn't exists"}.to_json
    end
end


  #-------------------------------------------------------------------------#

end