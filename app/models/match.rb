class Match < ActiveRecord::Base
  has_many :forecasts
  belongs_to :match_day
  belongs_to :home, class_name: "Team"
  belongs_to :away, class_name: "Team"

  def has_result
    self.result != nil and self.home_goals != nil and self.away_goals != nil 
  end

end