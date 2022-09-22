require 'mail'
module SessionHelper
  Mail.defaults do
    delivery_method :smtp, { 
      :address => 'smtp.gmail.com',
      :port => 587,
      :user_name => 'prodemania@gmail.com',
      :password => ENV['SECRET_APP_CODE'],
      :authentication => :plain,
      :enable_starttls_auto => true
    }
  end

    def new_singup
        erb :"players/signup"
        #and then docker-compose up 
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
        player = Player.new(params)

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

      def pw_lost_post
        player = Player.find_by_email(params[:email])
        if player
          logger.info(generateRandomPassword)
        end
      end


      def register_email_successfull(mailUser,userName)
          template = File.read("app/views/players/emailer.erb")
          mail = Mail.new do |m|
            m.from    'prodemania@gmail.com'
            m.to       mailUser
            m.subject 'Bienvenido a PRODE'
            m.html_part = template.gsub("{{name}}", userName)
          end
          mail.deliver
      end 
      
      def generateRandomPassword
        o = [('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
        string = (0...8).map { o[rand(o.length)] }.join
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