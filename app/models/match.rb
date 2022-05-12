class Match < ActiveRecord::Base
  has_many :forecasts
  belongs_to :match_day
  belongs_to :home, class_name: "Team"
  belongs_to :away, class_name: "Team"
end