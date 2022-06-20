module SessionHelper

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
        player = Player.new(params)

        if !player.save
					flash[:error] = "No se ha podido registrar el usuario"  
          redirect '/signup'
        else
          flash[:success] = "Usuario registrado con éxito!"
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
end