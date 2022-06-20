require 'sinatra/base'
require 'bundler/setup'
require 'sinatra/reloader' if Sinatra::Base.environment == :development
require 'logger'
require "sinatra/activerecord"
require_relative './models/init'
require 'sinatra/flash'

require_relative './helpers/game_helper'
require_relative './helpers/match_helper'
require_relative './helpers/forecast_helper'
require_relative './helpers/admin_helper'
require_relative './helpers/match_day_helper'

require_relative './helpers/team_helper'
require_relative './helpers/tournament_helper'
require_relative './helpers/session_helper'

class App < Sinatra::Application

  helpers GameHelperModule
  helpers MatchHelperModule
  helpers ForecastHelper
  helpers AdminHelper
  helpers MatchDayHelper

  helpers TeamHelper
  helpers TournamentHelper
  helpers SessionHelper

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
       admin_pages = ["/teams","/tournaments", "/matches","/match_day_create","/add_tournament","/gestion","/add_team"]
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
    new_singup
  end

  post '/signup' do
    new_authentication
  end

  get '/login' do
    new_login
  end

  post '/login' do
    create_login
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

  ## MATCHES ROUTES ##

  get '/matches' do
    matches
  end

  post '/matches' do
    create_match
  end

  put '/matches/:match_id' do
    update_match
  end

  delete '/matches/:match_id' do
    delete_match
  end

  ## END MATCHES ROUTES ##

  post '/forecasts' do
    post_forecast
  end

  get '/match_days/new' do
    new_match_days
  end 

  post '/match_days' do
    post_match_day
  end 

  delete '/match_days/:match_day_id' do
    delete_match_day
  end

  ## -- Tournament Controller -- ##
  get '/match_days' do 
    @match_days = MatchDay.where(:tournament_id == params[:tournament_id])
    erb :"jugar/match_days"
  end
  
  
 ## -- Add Team for Admin -- ##
 
post '/teams' do
  create_team
end

get '/teams/new' do
 new_team
end


delete '/teams/:team_id' do
  delete_team
end

## -- Tournament for Admin -- #

get '/tournaments' do
new_tournament
end

post '/tournaments' do 
name_tournament = params['name']
create_tournament (name_tournament)
end

delete '/tournaments/:id' do 
delete_tournament (params['id'])
end


## -- PROFILE -- ##
get '/profile' do
  @current_player = Player.find_by(id: session[:player_id])
  profile 
end


## ----------------------------- ##

get '/*' do
  redirect '/home'
end

end