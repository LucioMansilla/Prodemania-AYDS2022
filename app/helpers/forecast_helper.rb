
#Module ForecastHelper .. .
module ForecastHelper

    def post_forecast
        forecast = Forecast.check_match_player(session[:player_id], params[:match_id])
        forecast.result = params['result']
        forecast.home_goals = params['home_goals']
        forecast.away_goals = params['away_goals']
        if(forecast.resultConsist) then            
            forecast.tournament_id = params['tournament_id']
            logger.info(forecast)
            forecast.save
            flash[:success] = "Predicción creada con exito!"
        else
            flash[:error] = "Error el resultado no es consistente"
        end
        logger.info(params)
        redirect '/play?id_match_day=' + forecast.match.match_day_id.to_s + '&id_tournament=' + forecast.match.match_day.tournament_id.to_s

    end

    # def update_forecast
    #     forecast = Forecast.find_by(id: params['id'])
    #     if(forecast) then
    #         forecast.result = params['result']
    #         forecast.home_goals = params['home_goals']
    #         forecast.away_goals = params['away_goals']
    #         forecast.tournament_id = params['tournament_id']
    #         if(!forecast.check_match_player && forecast.resultConsist) then
    #             forecast.points = 0
    #             forecast.save
                
    #         else
    #             status 400
    #             {:status => 400, :mge => "There is already a prediction for that match"}.to_json
    #         end
    #     else
    #         status 400
    #         {:status => 404, :mge => "This forecast doesn't exists"}.to_json
    #     end
    # end

end
