module TeamHelper

    def new_team
        @tournaments = Tournament.all
        @teams = Team.all
        erb :"admin/teams", :layout => :layout_2
    end

    def create_team ()

        name_team = params['name']
        team = Team.new
        team.name = params['name']
        tournament = Tournament.all.where(name:params['tournament_names'])
        team.tournaments << tournament    

        if(!Team.exists?(name:name_team))
            if(team.save)
                flash[:success] = "El equipo fue creado con éxito."   
            else
                flash[:success] = "El equipo no pudo ser creado."   
            end
        else
            flash[:error] = "El equipo ya existe." 
        end

        redirect '/teams/new'   
      end   


      def delete_team
        team = Team.find(params['team_id'])
        if (team.destroy)
            flash[:success] = "El equipo fue eliminado con éxito"
            else
            flash[:error] = "El equipo no pudo ser eliminado"
            end
        redirect '/teams/new'
        end


end 


    
