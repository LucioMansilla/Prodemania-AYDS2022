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

  get '/gestion' do
    erb :"/admin/options"
  end


     ## -- Session -- ##
     before do
      if session[:player_id]
        @current_player = Player.find_by(id: session[:player_id])
       admin_pages = ["/teams","/tournaments","/matches","/match_day_create","/add_tournament","/gestion","/add_team"]
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

  ## -- Match Controller -- ##
  get '/matches' do
    @matches = Match.where(match_day_id: params[:match_day_id])
    erb :"jugar/matches"
  end

  post '/matches' do

    match = Match.new
    match.datetime = params['datetime']
    match.match_type = params['match_type']
    match.match_day_id = params['match_day_id']
    match.away_id = params['away_id']
    match.home_id = params['home_id']

    match.save
    status 201
    {:status => 201, :mge => "The match was created"}.to_json

  end

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

end
