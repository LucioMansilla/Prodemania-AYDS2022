# frozen_string_literal: true

module TournamentHelper
  def new_tournament
    @tournament = Tournament.all
    erb :"admin/tournaments", layout: :layout2
  end

  def update_t
    @id = params[:id]
    erb :"admin/tournament_update", layout: :layout2
  end

  def create_tournament(name_tournament)
    tournament = Tournament.new
    tournament.name = name_tournament

    if !Tournament.exists?(name: name_tournament)
      if tournament.save
        flash[:sucess] = 'El torneo fue creado con éxito.'
      else
        flash[:error] = 'El torneo no pudo ser creado.'
      end
    else
      flash[:error] = 'El torneo ya existe.'
    end

    redirect '/tournaments'
  end

  def delete_tournament(id)
    if Tournament.destroy(id)
      flash[:sucess] = 'El torneo fue eliminado con éxito.'
    else
      flash[:error] = 'El torneo no pudo ser eliminado.'
    end

    redirect '/tournaments'
  end

  def update_tournament
    id_tournament = params['id']
    new_name = params['name']

    logger.info(id_tournament)

    if !Tournament.exists?(name: new_name)

      update_t = Tournament.find_by(id: id_tournament)
      update_t.name = new_name
      update_t.save

      flash[:sucess] = 'El torneo fue actualizado con éxito.'

    else
      flash[:error] = 'El nombre del torneo ya existe'
    end

    redirect "/tournaments/update/#{id_tournament}"
  end
end
