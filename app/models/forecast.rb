# frozen_string_literal: true

class Forecast < ActiveRecord::Base
  belongs_to :player
  belongs_to :match
  belongs_to :tournament

  attr_accessor :old_points

  validates_presence_of :player_id, :home_goals, :away_goals, :tournament_id, :result, :match_id
  validates :result, acceptance: { accept: %w[HOME AWAY DRAW] }
  before_create :check_player_tournament
  def calculate_points
    self.old_points = points || 0

    total_points = 0
    if match.result? && guess_result
      total_points += 1
      total_points += 2 if guess_goals
    end

    self.points = total_points
    save

    total_points
  end

  def guess_result
    result == match.result
  end

  def guess_goals
    home_goals == match.home_goals && away_goals == match.away_goals
  end

  def check_player_tournament
    Point.create(player: player, tournament: tournament, total_points: 0) unless Point.exists?(
      tournament: tournament, player: player
    )
  end

  # return the forecast or the empty string if it doesn't exists
  def self.check_match_player(player_id, match_id)
    f = Forecast.find_by(player_id: player_id, match_id: match_id)
    if !f.nil?
      f
    else
      Forecast.new(player_id: player_id, match_id: match_id)
    end
  end

  def consistent_result
    if match.match_type == 'LEAGUE'
      consistent_result_league
    else
      consistent_result_elimination
    end
  end

  def consistent_result_league
    if result == 'HOME' && home_goals > away_goals
      true
    elsif result == 'AWAY' &&  home_goals < away_goals
      true
    elsif result == 'DRAW' &&  home_goals == away_goals
      true
    else
      false
    end
  end

  def consistent_result_elimination
    if result == 'HOME' && home_goals >= away_goals
      true
    elsif result == 'AWAY' && home_goals <= away_goals
      true
    else
      false
    end
  end
end
