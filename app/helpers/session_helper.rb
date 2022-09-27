require 'mail'
module SessionHelper
  Mail.defaults do
    delivery_method :smtp, { 
      :address => 'smtp.gmail.com',
      :port => 587,
      :user_name => 'luciomansillaztw@gmail.com',
      :password => ENV['SECRET_APP_CODE'],
      :authentication => :plain,
      :enable_starttls_auto => true
    }
  end

    def new_singup
        erb :"players/signup"
    end

    def new_authentication
				logger.info(params[:name])
				if Player.exists?(name: params[:name])
					flash[:error] = "Ya existe un usuario con ese nombre"
					redirect '/signup'
				end
				if Player.exists?(email: params[:email])
					flash[:error] = "Ya existe un usuario con ese email"
					redirect '/signup'
				end
        player = Player.new()
        player.name = params[:name]
        player.email = params[:email]
        player.password = params[:password]

        logger.info(player)
        if !player.save
					flash[:error] = "No se ha podido registrar el usuario"  
          redirect '/signup'
        else
          flash[:success] = "Usuario registrado con éxito!"
          mailUser = player.email
          register_email_successfull(mailUser, player.name)
          redirect '/login'
        end  
    end

    def new_login
        erb :"players/login"
    end

    def create_login
        player = Player.find_by_name(params[:name])
        if player && player.authenticate(params[:password])
        session[:player_id] = player.id 
        redirect '/inicio'
        else
        flash[:error] = "Contraseña y/o usuario incorrecto"
        redirect '/login'
        end
    end

    def profile 
        @player = Player.find_by_id(session[:player_id])
        erb :"players/profile", :layout => :layout_2
    end

    def update_player 
        current_player = Player.find_by_id(session[:player_id])
        if !Player.exists?(name: params[:name])
          current_player.name = params[:name]
        else
          flash[:error] = "Ya existe un usuario con ese nombre"
          redirect '/profile'
        end
    
        if params[:password] == params[:password_confirmation]
           current_player.password = params[:password]
           current_player.save
          flash[:success] = "Cambios guardados con éxito!"
          redirect '/profile'
        else
          flash[:error] = "Las contraseñas no coinciden"
          redirect '/profile'
        end
      end

      def pw_lost
        erb :"players/pw_lost", :layout => :layout
      end

      def pw_new
        player = PwRecovery.find_by_token(params[:token]).player
        if player
          player.password = params[:password]
          player.save
          PwRecovery.where(player_id: player.id).destroy_all
          flash[:success] = "Contraseña cambiada con éxito!"
          redirect '/login'
        else
          logger.info("no")
          flash[:error] = "Ha ocurrido un error"
          redirect '/pw-lost'
        end

      end


      def pw_lost_post
        player = Player.find_by_email(params[:email])
        logger.info(player)
        if player
          if(PwRecovery.exists?(player_id: player.id))
            PwRecovery.where(player_id: player.id).destroy_all
          end
          pw_recovery_obj = PwRecovery.new
          token = generateRandomPassword(8) #el harcodeo del 10 tmb
          string_token = generateRandomPassword(100) #esto se debe refactorizar
          pw_recovery_obj.player_id = player.id
          pw_recovery_obj.token = token
          pw_recovery_obj.save
          send_email_recovery(player.email, token,string_token, player.name)
          mailSplitAfter3 = player.email.split("@")
          #mailSplitothemiddle[0].slice(0,4);
          mailSplitBefore3 = mailSplitAfter3[0].slice(0,3)

          flash[:success] = "Por favor revise su correo electrónico: " + mailSplitBefore3 + "@****.com para un enlace de recuperación de contraseña" 
          redirect '/pw-lost'
        else
          flash[:error] = "No existe ningún usuario con ese email"
          redirect '/pw-lost'
        end
      end

      def pw_lost_token(token)
        pw_recovery_obj = PwRecovery.find_by_token(token)
        if pw_recovery_obj
          @player = Player.find_by_id(pw_recovery_obj.player_id)
          @username = @player.name
          @token = token
          erb :"players/new_password", :layout => :layout
        else
          flash[:error] = "El token ha expirado"
          redirect '/pw-lost'
        end
      end

      def send_email_recovery(mailUser, token,string_token,userName)
        template = File.read('app/views/players/emails/email_change_password.erb')
        mail = Mail.new do |m|
          m.from     'luciomansillaztw@gmail.com'
          m.to       mailUser
          m.subject  'Recuperación de contraseña'
          m.html_part = template.gsub("{{token}}", token).gsub("{{string_token}}", string_token).gsub("{{name}}", userName)
        end
        mail.deliver!
      end

      def register_email_successfull(mailUser,userName)
          template = File.read("app/views/players/emails/emailer.erb")
          mail = Mail.new do |m|
            m.from    'PRODEMANIA'
            m.to       mailUser
            m.subject 'Bienvenido a PRODE'
            m.html_part = template.gsub("{{name}}", userName)
          end
          mail.deliver
      end 
      
      def generateRandomPassword(length)
        o = [('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
        string = (0...length).map { o[rand(o.length)] }.join
        return string
      end

      
      
      def email_update_successfull(mailUser,userName)
        template = File.read("app/views/players/password_update.erb")
        mail = Mail.new do |m|
          m.from    'prodemania@gmail.com'
          m.to      mailUser
          m.subject 'Actualización de contraseña'
          m.html_part = template.gsub("{{name}}", userName)
        end
      end

end