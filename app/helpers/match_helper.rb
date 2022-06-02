module MatchHelperModule

  def new_match
    @tournaments = Tournament.all 

    if(params['id_tournament'])
      @torneo_selected = true
      @selected_tournament = Tournament.find_by_id(params['id_tournament'])
      @match_days = MatchDay.where(tournament_id: params['id_tournament'])
    end

    erb :"admin/new_match"
  end

  def create_match

    match = Match.new
    match.datetime = params['datetime']
    match.match_type = params['match_type']
    match.match_day_id = params['match_day_id']
    match.home_id = params['home_id']
    match.away_id = params['away_id']

    if(match.save)
      flash[:success] = "Partido creado con exito."
    else
      flash[:error] = "Error al crear partido. Intente nuevamente."
    end
    redirect '/matches/new'
  end

  def update_match

    match = Match.find_by_id(params[:match_id])
    match.result = params['result']
    match.home_goals = params['home_goals']
    match.away_goals = params['away_goals']

    if(match.save)
      flash[:success] = "Partido actualizado con exito."
    else
      flash[:error] = "Error al actualizar partido. Intente nuevamente."
    end
    redirect '/matches/update'

  end

  def matches 
    @tournaments = Tournament.all 

    if(params['id_tournament'])
      @torneo_selected = true
      @match_days = MatchDay.where(tournament_id: params['id_tournament'])
    end

    if(params['id_match_day'])
      @match_day_selected = true
      @matches = Match.where(match_day_id: params['id_match_day'])
    end

    erb :"admin/update_match"
  end

end