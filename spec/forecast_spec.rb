# frozen_string_literal: true

require_relative '../app/models/init'

describe 'Forecast' do
  describe '#points' do
    # crear un tournament
    tournament_1 = Tournament.new(name: 'Liga Argentina')

    # crear un matchday de ese tournament
    matchday_1 = MatchDay.new(description: 'Fecha 1', tournament: tournament_1)

    # crear dos teams
    team_1 = Team.new(name: 'Boca')
    team_2 = Team.new(name: 'River')

    # crear un match
    match_1 =  Match.new(match_type: 'LEAGUE', match_day: matchday_1, home: team_1, away: team_2)

    # crear un forecast
    forecast_1 = Forecast.new(result: 'HOME', home_goals: 2, away_goals: 1, match: match_1, tournament: tournament_1)

    describe "when match doesn't have result" do
      it 'should return 0' do
        expect(forecast_1.points).to eq(0)
      end
    end

    describe 'when forecast is totally correct' do
      it 'should return 3' do
        match_1.result = 'HOME'
        match_1.home_goals = 2
        match_1.away_goals = 1

        expect(forecast_1.points).to eq(3)
      end
    end

    describe 'when forecast is parcially correct' do
      it 'should return 1' do
        match_1.result = 'HOME'
        match_1.home_goals = 3
        match_1.away_goals = 2

        expect(forecast_1.points).to eq(1)
      end
    end

    describe 'when forecast is wrong' do
      it 'should return 0' do
        match_1.result = 'AWAY'
        match_1.home_goals = 0
        match_1.away_goals = 1

        expect(forecast_1.points).to eq(0)
      end
    end
  end
end
