require 'sinatra/base'
require 'bundler/setup'
require 'sinatra/reloader' if Sinatra::Base.environment == :development
require 'logger'
require "sinatra/activerecord"
require_relative '../models/init'
require 'sinatra/flash'

require_relative '../helpers/game_helper'
require_relative '../helpers/match_helper'
require_relative '../helpers/forecast_helper'
require_relative '../helpers/admin_helper'
require_relative '../helpers/match_day_helper'

class App < Sinatra::Application

  helpers GameHelperModule
  helpers MatchHelperModule
  helpers ForecastHelper
  helpers AdminHelper
  helpers MatchDayHelper

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
    register Sinatra::Flash
    set :views, 'app/views'
    set :public_folder, 'public'
    set :sessions, true
    set :session_secret, ENV.fetch('SESSION_SECRET') { SecureRandom.hex(64) }
  end


  def initialize(app = nil)
    super()
  end

  get '/gestion' do
    get_menu_admin
  end

     ## -- Session -- ##
     before do
      if session[:player_id]
        @current_player = Player.find_by(id: session[:player_id])
       admin_pages = ["/teams","/tournaments","/matches/new", "/matches/update" ,"/match_day_create","/add_tournament","/gestion","/add_team"]
       if(admin_pages.include?(request.path_info))
         if(@current_player.is_admin != true)
           redirect '/inicio'
         end
       end
      else
        public_pages = ["/login", "/signup"]
        if !public_pages.include?(request.path_info)
          redirect '/login'
        end
      end
    end
    ## -- Session -- ##


  ##--- Player Controller ---##
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
      redirect '/home'
    else
      redirect '/login'
    end
  end

  get '/logout' do
    session.clear
    redirect '/login'
  end

  get '/home' do 
    home
  end

  get '/play' do 
    play
  end

  get '/points' do
    points
  end

  get '/matches/new' do
    new_match
  end

  get '/matches/update' do
    matches
  end

  post '/matches' do
    create_match
  end

  put '/matches' do
    update_match
  end

  post '/forecasts' do
    post_forecast
  end

  get '/match_days/new' do
    new_match_days
  end 

  post '/match_days' do
    post_match_day
  end 




  ## -- Tournament Controller -- ##
  get '/match_days' do 
    @match_days = MatchDay.where(:tournament_id == params[:tournament_id])
    erb :"jugar/match_days"
  end
  
  post '/tournaments' do
  
    name_tournament = params['name']

    tournament = Tournament.new
    tournament.name = name_tournament
    logger.info "Params: #{params.to_s}"
    @tournaments = Tournament.all
    if(!Tournament.exists?(name:name_tournament) && tournament.save)
        @msg = {status: 200, msg: "Tournament created"}
        
        erb :'admin/tournaments'
    else
        @msg = {status: 400, msg: "Tournament already exists"}
        erb :'admin/tournaments'
    end
  
  end
  
  delete '/tournaments/:id' do 
  
    Tournament.destroy(params['id'])
    {:status => 204, :mge => "Delete tournament #{params[:id]}"}.to_json
  
  end

 ## -- Tournament Controller -- ##




  #-------------------------------------------------------------------------#


  ## -- Teams Controller -- ##

  post '/teams' do
  
    name_team = params['name']
    team = Team.new
    team.name = name_team
    tournament = Tournament.all.where(name:params['tournament_name'])
    team.tournaments << tournament
    ok = team.save
    @tournaments = Tournament.all
    if(ok)
        @msg = {status: 200, msg: "The team was created"}
    
        erb :'admin/teams'
    else
        @msg = {status: 400, msg: "The team exists"}

        erb :'/admin/teams'
    end

  end   

  ## -- Teams Controller -- ##




## -- Tournament for Admin -- #
get '/add_tournament' do
  @tournaments = Tournament.all
  erb :"admin/tournaments"
end



## -- Add Team for Admin -- ##
get '/add_team' do
  @tournaments = Tournament.all
  erb :"admin/teams"
end

get '/*' do
  redirect '/home'
end

end
