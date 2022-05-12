class Forecast < ActiveRecord::Base
    belongs_to :player 
    belongs_to :match
    belongs_to :tournament
end