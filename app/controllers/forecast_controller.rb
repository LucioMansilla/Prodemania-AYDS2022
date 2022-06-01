class ForecastController < App
    get '/forecasts' do
        logger.info "123"
        logger.info session
        Forecast.first.to_json
    end

  ## ----forecasts controller----- ##
  post '/forecasts' do
    forecast = Forecast.new
    forecast.match_id = params['match_id']
    forecast.player_id = session['player_id']
    forecast.result = params['result']
    forecast.home_goals = params['home_goals']
    forecast.away_goals = params['away_goals']
    forecast.tournament_id = params['tournament_id']
    logger.info(params)
    if(!forecast.check_match_player && forecast.resultConsist) then
        forecast.save
        redirect '/matches?match_day_id=' + forecast.match.match_day_id.to_s
    else
        status 400
        {:status => 400, :mge => "There is already a prediction for that match"}.to_json
    end
end

put '/forecasts/:id' do
    forecast = Forecast.find_by(id: params['id'])
    if(forecast) then
        forecast.result = params['result']
        forecast.home_goals = params['home_goals']
        forecast.away_goals = params['away_goals']
        forecast.tournament_id = params['tournament_id']
        if(!forecast.check_match_player && forecast.resultConsist) then
            forecast.points = 0
            forecast.save
             
        else
            status 400
            {:status => 400, :mge => "There is already a prediction for that match"}.to_json
        end
    else
        status 400
        {:status => 404, :mge => "This forecast doesn't exists"}.to_json
    end
end

end

