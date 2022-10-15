# frozen_string_literal: true

module ProfileHelper
  def profile
    @player = Player.find_by_id(session[:player_id])
    erb :"players/profile", layout: :layout2
  end

  def update_player
    current_player = Player.find_by_id(session[:player_id])
    if !Player.exists?(name: params[:name])
      current_player.name = params[:name]
    else
      flash[:error] = 'Ya existe un usuario con ese nombre'
      redirect '/profile'
    end

    if params[:password] == params[:password_confirmation]
      current_player.password = params[:password]
      current_player.save
      flash[:success] = 'Cambios guardados con éxito!'
    else
      flash[:error] = 'Las contraseñas no coinciden'
    end
    redirect '/profile'
  end
end
