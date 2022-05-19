require 'sinatra/reloader' if Sinatra::Base.environment == :development
require 'logger'
require_relative '../models/forecast'
require 'sinatra/activerecord'


class Forecast_Controller < Sinatra::Base
    post '/forecast' do
        forecast = Forecast.new
        forecast.match_id = params['match_id']
        forecast.player_id = params['player_id']
        forecast.result = params['result']
        forecast.home_goals = params['home_goals']
        forecast.away_goals = params['away_goals']
        forecast.tournament_id = params['tournament_id']
        if(!forecast.check_match_player && forecast.resultConsist) then
            forecast.save
        else
            status 400
            {:status => 400, :mge => "There is already a prediction for that match"}.to_json
        end
    end

    put '/forecast/:id' do
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

