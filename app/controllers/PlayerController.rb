require 'sinatra/reloader' if Sinatra::Base.environment == :development
require 'logger'
require_relative '../models/player'
require 'sinatra/activerecord'

class PlayerController < Sinatra::Base

    get '/players' do
        Player.all.to_json
    end

    get '/players/:id' do
        Player.find(params[:id]).to_json
    end
    
   post '/players' do
        player = JSON.parse(request.body.read)
        logger.info "player: #{player}"
        Player.create(player)
        player.to_json
   end 

   put '/players/:id' do
        player = JSON.parse(request.body.read)
        logger.info "player: #{player}"
        playerOk = Player.find(params['id'])
        if playerOk
            playerOk.update(player)
        else
            halt 404, "Player not found" 
        end
        player.to_json
   end


   delete '/players/:id' do 
        Player.destroy(params['id'])
        #return 200
        status 204
   end


end




