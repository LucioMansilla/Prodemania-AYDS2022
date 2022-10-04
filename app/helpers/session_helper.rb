# frozen_string_literal: true

require 'mail'
module SessionHelper
  Mail.defaults do
    delivery_method :smtp, {
      address: 'smtp.gmail.com',
      port: 587,
      user_name: 'luciomansillaztw@gmail.com',
      password: ENV['SECRET_APP_CODE'],
      authentication: :plain,
      enable_starttls_auto: true
    }
  end

  def new_singup
    erb :"players/signup"
  end

  def new_authentication
    logger.info(params[:name])
    if Player.exists?(name: params[:name])
      flash[:error] = 'Ya existe un usuario con ese nombre'
      redirect '/signup'
    end
    if Player.exists?(email: params[:email])
      flash[:error] = 'Ya existe un usuario con ese email'
      redirect '/signup'
    end
    player = Player.new
    player.name = params[:name]
    player.email = params[:email]
    player.password = params[:password]

    logger.info(player)
    if !player.save
      flash[:error] = 'No se ha podido registrar el usuario'
      redirect '/signup'
    else
      flash[:success] = 'Usuario registrado con éxito!'
      mail_user = player.email
      register_email_successfull(mail_user, player.name)
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
      logger.info('no')
      flash[:error] = 'Ha ocurrido un error'
      redirect '/pw-lost'
    end
  end

  def pw_lost_post
    player = Player.find_by_email(params[:email])
    logger.info(player)
    if player
      PwRecovery.where(player_id: player.id).destroy_all if PwRecovery.exists?(player_id: player.id)
      pw_recovery_obj = PwRecovery.new
      token = generate_random_password(8) # el harcodeo del 10 tmb
      string_token = generate_random_password(100) # esto se debe refactorizar
      pw_recovery_obj.player_id = player.id
      pw_recovery_obj.token = token
      pw_recovery_obj.save
      send_email_recovery(player.email, token, string_token, player.name)
      mail_split_after3 = player.email.split('@')
      # mailSplitothemiddle[0].slice(0,4);
      mail_split_before3 = mail_split_after3[0].slice(0, 3)

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

  def send_email_recovery(mail_user, token, string_token, user_name)
    template = File.read('app/views/players/emails/email_change_password.erb')
    mail = Mail.new
    mail do |m|
      m.from     'luciomansillaztw@gmail.com'
      m.to       mail_user
      m.subject  'Recuperación de contraseña'
      m.html_part = template.gsub('{{token}}', token).gsub('{{string_token}}', string_token).gsub('{{name}}',
                                                                                                  user_name)
    end
    mail.deliver!
  end

  def register_email_successfull(mail_user, user_name)
    template = File.read('app/views/players/emails/emailer.erb')
    mail = Mail.new
    mail do |m|
      m.from 'PRODEMANIA'
      m.to mail_user
      m.subject 'Bienvenido a PRODE'
      m.html_part = template.gsub('{{name}}', user_name)
    end
    mail.deliver
  end

  def generate_random_password(length)
    o = [('a'..'z'), ('A'..'Z')].map(&:to_a).flatten
    (0...length).map { o[rand(o.length)] }.join
  end

  def email_update_successfull(mail_user, user_name)
    template = File.read('app/views/players/password_update.erb')
    mail = Mail.new
    mail do |m|
      m.from    'prodemania@gmail.com'
      m.to      mail_user
      m.subject 'Actualización de contraseña'
      m.html_part = template.gsub('{{name}}', user_name)
    end
  end
end
