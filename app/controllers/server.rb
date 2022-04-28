require 'sinatra/base'
require 'bundler/setup'
require 'sinatra/reloader' if Sinatra::Base.environment == :development
class App < Sinatra::Application
  
  configure :development do
    register Sinatra::Reloader
    after_reload do
      puts 'Reloaded...'
    end
  end

  configure do 
    set :views, 'app/views'
  end

  def initialize(app = nil)
    super()
  end

  user = [
    {name: 'Juan', email: 'juan@gmail.com',password:'12345'},
    {name: 'Pedro', email: 'pedro@gmail.com',password:'12345'},
    {name: 'Ana', email: 'ana@gmail.com',password:'12345'}
  ]


  get '/users2/:name' do
    user.find { |u| u[:name] == params[:name] }.to_s
  end

  #post
  post '/users' do
    user.push(params)
    user.to_json
  end

  get '/users' do
    erb:user
  end 

end