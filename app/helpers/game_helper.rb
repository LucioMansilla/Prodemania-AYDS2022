module GameHelperModule

  def home
    erb :'home', :layout => :layout_2
  end

  def play
    @tournaments = Tournament.all 

    if(params['id_tournament'])
      @torneo_selected = true
      @match_days = MatchDay.where(tournament_id: params['id_tournament'])
    end

    if(params['id_match_day'])
      @match_day_selected = true
      @matches = Match.where(match_day_id: params['id_match_day'])
    end

    erb :"play/play", :layout => :layout_2
  end

  def points
    @tournaments = Tournament.all 

    if(params['id_tournament'])
      @torneo_selected = true
      @points = Point.where(tournament_id: params['id_tournament'])
    end

    erb :"points/points"
  end

end