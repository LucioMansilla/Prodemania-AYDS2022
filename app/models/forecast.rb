class Forecast < ActiveRecord::Base
    belongs_to :player 
    belongs_to :match
    belongs_to :tournament

    attr_accessor :old_points
  
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
      self.goals_home == self.match.goals_home && self.goals_away == self.match.goals_away
    end
end