module SessionHelper

    def new_singup
        erb :"players/signup"
    end

    def new_authentication
        player = Player.new(params)
    
        if !player.save  
          redirect '/signup'
        else
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
        flash[:error] = "Contraseña y/o usario incorrecto"
        redirect '/login'
        end
    end

end