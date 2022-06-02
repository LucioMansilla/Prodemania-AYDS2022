
#Module ForecastHelper .. .
module ForecastHelper
    def test_forecast #Test forecasts 
        logger.info "123"
        logger.info session
        "hello"
    end         

def post_forecast
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
        flash[:success] = "Forecast created"
        redirect '/matches?match_day_id=' + forecast.match.match_day_id.to_s
    else
        flash[:error] = "Error, there is already a forecast for this match or the result is not consistent" 
        redirect '/matches?match_day_id=' + forecast.match.match_day_id.to_s
    end
end

def update_forecast
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
