# frozen_string_literal: true

module GameHelperModule
  def home
    # load session user
    @user = Player.find_by_id(session[:user_id])
    erb :home, layout: :layout2
  end

  def play
    @tournaments = Tournament.all

    if params['id_tournament']
      @torneo_selected = true
      @match_days = MatchDay.where(tournament_id: params['id_tournament'])
    end

    if params['id_match_day']
      @match_day_selected = true
      @matches = Match.where(match_day_id: params['id_match_day'])
    end

    erb :"play/play", layout: :layout2
  end

  def points
    @tournaments = Tournament.all

    if params['id_tournament']
      @id_tournament = params['id_tournament']
      @torneo_selected = true
      @points = Point.where(tournament_id: params['id_tournament']).order(total_points: :desc)
    end

    erb :"points/points", layout: :layout2
  end
end
