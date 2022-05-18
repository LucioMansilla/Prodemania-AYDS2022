class Team < ActiveRecord::Base
  has_many :away_matches, foreign_key: 'away_id', class_name: 'Match'
  has_many :home_matches, foreign_key: 'home_id', class_name: 'Match'
  has_and_belongs_to_many :tournaments
end