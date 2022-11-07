# frozen_string_literal: true

module TeamStatisticsHelper

  def team_statistics
    @team = Team.find_by(name: params['name'])
    home_match_results = match_results(@team.home_matches, 'HOME')
    away_match_results = match_results(@team.away_matches, 'AWAY')
    @win = home_match_results['win'] + away_match_results['win']
    @lose = home_match_results['lose'] + away_match_results['lose']
    @draw = home_match_results['draw'] + away_match_results['draw']
    @efectivity = ((@win*3 + @draw).to_f / ((@win + @draw + @lose) * 3) * 100).round(2)
    erb :"statistics/team_statistics", layout: :layout2
  end

  def match_results(home_matches, type) 
    win = 0
    lose = 0
    draw = 0
    home_matches.each do |match|
      if match.result? 
        if match.result == type
          win += 1
        elsif match.result == "DRAW"
          draw += 1
        else 
          lose += 1
        end
      end
    end
    {'win' => win, 'lose' => lose, 'draw' => draw}
  end

end
