module StatisticsHelper

  def get_statistics

    @tournaments = Tournament.all 
    @tournament_selected = false 
    forecast = nil
    
    if params['tournament'] == 'all'
      forecasts = Forecast.where(player_id: params['player_id'])
    else
      forecasts = Forecast.where(player_id: params['player_id']).where(tournament_id: params['tournament'])
    end

    if params['tournament']
      @tournament_selected = true  
      @fails = 0
      @successes = 0
      @partial_successes = 0
      forecasts.each do |forecast|
        if forecast.match.result 
          if (forecast.guess_result && forecast.guess_goals)
            @successes += 1
          elsif forecast.guess_result
            @partial_successes += 1 
          else
            @fails += 1
          end
        else
        end   
      end
    end

    erb :"statistics/statistics", :layout => :layout_2
  end

end