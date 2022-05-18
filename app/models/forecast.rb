class Forecast < ActiveRecord::Base
    belongs_to :player 
    belongs_to :match
    belongs_to :tournament

    attr_accessor :old_points
  
    before_create :check_player_tournament
    def calculate_points
      
      self.old_points = self.points ? self.points : 0
  
      total_points = 0
      if self.match.has_result?
        if self.guess_result 
          total_points += 1
    
          if self.guess_goals
            total_points += 2
          end   
        end 
      end
  
      self.points = total_points
      self.save
  
      total_points
    end
  
    def guess_result
      self.result == self.match.result  
    end
  
    def guess_goals 
      self.home_goals == self.match.home_goals && self.away_goals == self.match.away_goals
    end

    def check_player_tournament
      if !Point.exists?(tournament: self.tournament, player: self.player)
        Point.create(player: self.player, tournament: self.tournament, total_points: 0)
      end
    end

    def check_match_player
        Forecast.exists?(player_id: self.player_id, match_id: self.match_id)
    end
    
end