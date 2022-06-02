module TournamentHelper

    def new_tournament
        @tournament = Tournament.all
        erb :"admin/tournaments"
    end

    def create_tournament (name_tournament)

        tournament = Tournament.new
        tournament.name = name_tournament
        
        if(!Tournament.exists?(name:name_tournament) && tournament.save)
            flash[:sucess] = "El torneo fue creado"
        else
            flash[:error] = "El torneo ya existe"
        end

        redirect '/tournaments/new'
    
    end

    def delete_tournament (id)

        Tournament.destroy(id)
        {:status => 204, :mge => "Delete tournament #{id}"}.to_json

    end


end
