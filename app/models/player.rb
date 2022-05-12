class Player < ActiveRecord::Base
  
    has_many :forecasts 
    has_many :points 
    has_many :tournaments, through: :points
  
  end