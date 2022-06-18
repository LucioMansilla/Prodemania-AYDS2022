class Match < ActiveRecord::Base
  has_many :forecasts, dependent: :destroy
  belongs_to :match_day
  belongs_to :home, class_name: "Team"
  belongs_to :away, class_name: "Team"

  before_update :calculate_points,  if: :result_or_goals_changed?
  validates_presence_of :match_type, :home_id, :away_id, :match_day_id
  validates :result, acceptance: { accept: ['HOME', 'AWAY','DRAW'] }
  validates :match_type, acceptance: { accept: ['LEAGUE', 'ELIMINATION'] }

  def has_result?
    self.result != nil and self.home_goals != nil and self.away_goals != nil
  end

  def set_result(result, home_goals, away_goals)
    self.result = result 
    self.home_goals = home_goals
    self.away_goals = away_goals
  end

  def calculate_points 
    self.forecasts.each do |forecast|
      forecast_points = forecast.calculate_points 
      
      point = Point.find_by(player_id: forecast.player_id, tournament_id: forecast.tournament_id)
      
      point.total_points += forecast_points - forecast.old_points
      
      point.save
    end
  end

  def result_or_goals_changed? 
    self.result_changed? || self.home_goals_changed? || self.away_goals_changed? 
  end
  
  def consistentResult
    if self.match_type == 'LEAGUE'
      if self.result == 'HOME' &&  self.home_goals > self.away_goals
        return true
      elsif self.result == 'AWAY' &&  self.home_goals < self.away_goals
          return true
      elsif self.result == 'DRAW' &&  self.home_goals == self.away_goals
          return true
      else
          return false
      end
    else
      if self.result == 'HOME' &&  self.home_goals >= self.away_goals
        return true
      elsif self.result == 'AWAY' &&  self.home_goals <= self.away_goals
          return true
      else
          return false
      end
    end
      
  end
end