class Team < ActiveRecord::Base
  has_many :away_matches, foreign_key: 'away_id', class_name: 'Match', dependent: :destroy
  has_many :home_matches, foreign_key: 'home_id', class_name: 'Match', dependent: :destroy
  has_and_belongs_to_many :tournaments

  validates :name, presence: true
  validates_uniqueness_of :name

end