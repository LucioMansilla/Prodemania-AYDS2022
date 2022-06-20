module MatchDayHelper   
  ## -- Math_Day Controller -- ##

  def new_match_days
    @tournaments = Tournament.all
    @match_days = MatchDay.all
    erb :"admin/new_match_days", :layout => :layout_2
  end
  
  def post_match_day
    match_day = MatchDay.new
    match_day.description = params['description']
    match_day.tournament_id = Tournament.find_by(name: params['tournament_name']).id
    match = MatchDay.exists?(description: match_day.description, tournament_id: match_day.tournament_id)
    if(match)
     # @msg = {status: 400, msg: "Match day already exists"}
     flash[:error] = "Match day already exists" 
     redirect '/match_days/new'
    end
    if (match_day.save)
      flash[:success] = "Match day created"
      #@msg = {status: 201, msg: "Match day created"}
    else
      flash[:error] = "Match day not created"
      #@msg = {status: 400, msg: "Match day not created, try again"}
    end
    #@tournaments = Tournament.all
    #erb :"admin/match_days"
    redirect '/match_days/new'
  end


  def delete_match_day
    match_day = MatchDay.find(params['match_day_id'])
    if (match_day.destroy)
      flash[:success] = "Match day deleted"
    else
      flash[:error] = "Match day not deleted"
    end
    redirect '/match_days/new'
  end
end
## -- Match_Day Controller -- ##