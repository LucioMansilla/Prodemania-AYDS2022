# frozen_string_literal: true

module StatisticsHelper
  def statistics
    @tournaments = Tournament.all
    @tournament_selected = false
    @efectivity = 0
    @total_points = 0

    if params['tournament']
      @tournament_selected = true
      prediction_results = calculate_prediction_results(forecasts(params['tournament']))
      points = calculate_points(forecasts(params['tournament']))
      @total_points = points['total_points']
      @efectivity = ((points['points'].to_f / points['total_points']) * 100).round(2)
      @fails = prediction_results['fails']
      @successes = prediction_results['successes']
      @partial_successes = prediction_results['partial_successes']
    end

    errb :"statistics/statistics", layout: :layout2
  end

  def forecasts(tournament)
    if tournament == 'all'
      Forecast.where(player_id: params['player_id'])
    else
      Forecast.where(player_id: params['player_id']).where(tournament_id: tournament)
    end
  end

  def calculate_points(forecasts)
    points = 0
    total_points = 0
    forecasts.each do |forecast|
      next unless forecast.match.result

      total_points += 3
      points += forecast.points
    end

    { 'points' => points, 'total_points' => total_points }
  end

  def calculate_prediction_results(forecasts)
    successes = 0
    partial_successes = 0
    fails = 0
    forecasts.each do |forecast|
      next unless forecast.match.result

      if forecast.guess_result && forecast.guess_goals
        successes += 1
      elsif forecast.guess_result
        partial_successes += 1
      else
        fails += 1
      end
    end
    { 'succeses' => successes, 'partial_successes' => partial_successes, 'fails' => fails }
  end
end
