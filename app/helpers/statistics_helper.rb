module StatisticsHelper

  def get_statistics

    @tournaments = Tournament.all 
    @tournament_selected = false 
    forecast = nil
    @efectivity = 0
    @points = 0
    @total_points = 0
    
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
          @total_points += 3
          @points += forecast.points
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

      @efectivity = ((@points.to_f / @total_points.to_f) * 100).round(2)
    end

    erb :"statistics/statistics", :layout => :layout_2
  end

end