class Forecast < ActiveRecord::Base
    belongs_to :player 
    belongs_to :match
    belongs_to :tournament

    def points

        total_points = 0
        
        if self.match.has_result 
            if self.guess_result
                total_points += 1

                if self.guess_goals
                    total_points += 2
                end
            end
        end
        total_points
    end

    def guess_result
        self.result == self.match.result
    end

    def guess_goals
        self.home_goals == self.match.home_goals and self.away_goals == self.match.away_goals
    end
end