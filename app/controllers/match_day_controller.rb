class MatchDayController < App 
    
  ## -- Math_Day Controller -- ##

  get '/match_days/new' do
    @tournaments = Tournament.all
    erb :"admin/match_days"
  end
  
  post '/match_days' do
    match_day = MatchDay.new
    match_day.description = params['description']
    match_day.tournament_id = Tournament.find_by(name: params['tournament_name']).id
    match = MatchDay.exists?(description: match_day.description, tournament_id: match_day.tournament_id)
    if(match)
      @msg = {status: 400, msg: "Match day already exists"}
      @tournaments = Tournament.all
      return  erb :'admin/match_days'
    end
    if (match_day.save)
      @msg = {status: 201, msg: "Match day created"}
    else
      @msg = {status: 400, msg: "Match day not created, try again"}
    end
    @tournaments = Tournament.all
    erb :"admin/match_days"
  end

## -- Match_Day Controller -- ##
end
