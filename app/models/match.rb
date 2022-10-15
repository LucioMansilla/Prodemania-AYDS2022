# frozen_string_literal: true

class Match < ActiveRecord::Base
  has_many :forecasts, dependent: :destroy
  belongs_to :match_day
  belongs_to :home, class_name: 'Team'
  belongs_to :away, class_name: 'Team'

  before_update :calculate_points, if: :result_or_goals_changed?
  validates_presence_of :match_type, :home_id, :away_id, :match_day_id
  validates :result, acceptance: { accept: %w[HOME AWAY DRAW] }
  validates :match_type, acceptance: { accept: %w[LEAGUE ELIMINATION] }

  def result?
    !result.nil? and !home_goals.nil? and !away_goals.nil?
  end

  def set_result(result, home_goals, away_goals)
    self.result = result
    self.home_goals = home_goals
    self.away_goals = away_goals
  end

  def calculate_points
    forecasts.each do |forecast|
      forecast_points = forecast.calculate_points

      point = Point.find_by(player_id: forecast.player_id, tournament_id: forecast.tournament_id)

      point.total_points += forecast_points - forecast.old_points

      point.save
    end
  end

  def result_or_goals_changed?
    result_changed? || home_goals_changed? || away_goals_changed?
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
