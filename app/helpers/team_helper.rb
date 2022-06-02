module TeamHelper

    def new_team
        @tournaments = Tournament.all
        erb :"admin/teams"
    end

    def create_team ()

        name_team = params['name']
        team = Team.new
        team.name = params['name']
        tournament = Tournament.all.where(name:params['tournament_name'])
        team.tournaments << tournament    

        if(!Team.exists?(name:name_team) && team.save)
            flash[:sucess] = "El team fue creado"             
        else
            flash[:error] = "El team ya existe"        
        end

        redirect '/teams/new'   
    
      end   

end 


    
