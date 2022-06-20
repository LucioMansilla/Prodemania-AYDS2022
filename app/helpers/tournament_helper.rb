module TournamentHelper

    def new_tournament
        @tournament = Tournament.all
        erb :"admin/tournaments", :layout => :layout_2
    end

    def create_tournament (name_tournament)

        tournament = Tournament.new
        tournament.name = name_tournament

        if(!Tournament.exists?(name:name_tournament))
            if(tournament.save)
                flash[:sucess] = "El torneo fue creado con éxito."
            else
                flash[:error] = "El torneo no pudo ser creado."
            end
        else
            flash[:error] = "El torneo ya existe."
        end

        redirect '/tournaments'
    
    end

    def delete_tournament (id)

        if(Tournament.destroy(id))
            flash[:sucess] = "El torneo fue eliminado con éxito."
        else
            flash[:error] = "El torneo no pudo ser eliminado."
        end

        redirect '/tournaments'

    end


end
