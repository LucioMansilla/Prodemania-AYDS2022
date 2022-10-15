# frozen_string_literal: true

module SessionHelper
  def new_singup
    erb :"players/signup"
  end

  def new_authentication
    if Player.exists?(name: params[:name])
      flash[:error] = 'Ya existe un usuario con ese nombre'
      redirect '/signup'
    end
    if Player.exists?(email: params[:email])
      flash[:error] = 'Ya existe un usuario con ese email'
      redirect '/signup'
    end
    player = Player.new(name: params[:name], email: params[:email], password: params[:password])
    if !player.save
      flash[:error] = 'No se ha podido registrar el usuario'
      redirect '/signup'
    else
      flash[:success] = 'Usuario registrado con éxito!'
      register_email_successfull(player.email, player.name)
      redirect '/login'
    end
  end

  def new_login
    erb :"players/login"
  end

  def create_login
    player = Player.find_by_name(params[:name])
    if player&.authenticate(params[:password])
      session[:player_id] = player.id
      redirect '/inicio'
    else
      flash[:error] = 'Contraseña y/o usuario incorrecto'
      redirect '/login'
    end
  end

  def pw_lost
    erb :"players/pw_lost", layout: :layout
  end

  def pw_new
    player = PwRecovery.find_by_token(params[:token]).player
    if player
      player.password = params[:password]
      player.save
      PwRecovery.where(player_id: player.id).destroy_all
      flash[:success] = 'Contraseña cambiada con éxito!'
      redirect '/login'
    else
      flash[:error] = 'Ha ocurrido un error'
      redirect '/pw-lost'
    end
  end

  def pw_lost_post
    player = Player.find_by_email(params[:email])
    if player
      PwRecovery.where(player_id: player.id).destroy_all if PwRecovery.exists?(player_id: player.id)
      token = generate_random_password(8) # el harcodeo del 10 tmb
      string_token = generate_random_password(100) # esto se debe refactorizar
      pw_recovery_obj = PwRecovery.new(player_id: player.id, token: token)
      pw_recovery_obj.save
      send_email_recovery(player.email, token, string_token, player.name)
      mail_split_before3 = player.email.split('@').slice(0, 3)
      flash[:success] =
        "Por favor revise su correo electrónico: #{mail_split_before3}@****.com \
        para un enlace de recuperación de contraseña"
    else
      flash[:error] = 'No existe ningún usuario con ese email'
    end
    redirect '/pw-lost'
  end

  def pw_lost_token(token)
    pw_recovery_obj = PwRecovery.find_by_token(token)
    if pw_recovery_obj
      @player = Player.find_by_id(pw_recovery_obj.player_id)
      @username = @player.name
      @token = token
      erb :"players/new_password", layout: :layout
    else
      flash[:error] = 'El token ha expirado'
      redirect '/pw-lost'
    end
  end
end
