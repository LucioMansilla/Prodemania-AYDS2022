# frozen_string_literal: true

module TeamHelper
  def new_team
    @tournaments = Tournament.all
    @teams = Team.all
    erb :"admin/teams", layout: :layout2
  end

  def create_team
    name_team = params['name']
    team = Team.new
    team.name = params['name']
    tournament = Tournament.all.where(name: params['tournament_names'])
    team.tournaments << tournament

    if !Team.exists?(name: name_team)
      flash[:success] = if team.save
                          'El equipo fue creado con éxito.'
                        else
                          'El equipo no pudo ser creado.'
                        end
    else
      flash[:error] = 'El equipo ya existe.'
    end

    redirect '/teams/new'
  end

  def delete_team
    team = Team.find(params['team_id'])
    if team.destroy
      flash[:success] = 'El equipo fue eliminado con éxito'
    else
      flash[:error] = 'El equipo no pudo ser eliminado'
    end
    redirect '/teams/new'
  end

  def update_team_tournament
    team = Team.find_by_id(params['id'])
    tournament = Tournament.all.where(name: params['tournament_names'])
    team.tournaments << tournament

    flash[:success] = if team.save
                        'El equipo fue actualizado con éxito.'
                      else
                        'El equipo no pudo ser actualizado.'
                      end

    redirect '/teams/new'
  end

  def update_team
    tournaments = Tournament.all
    @team = Team.find_by_id(params['team_id'])
    @tournaments_to_choice = tournaments.reject { |t| @team.tournaments.include?(t) }
    erb :'admin/update_team', layout: :layout2
  end
end
