require 'sinatra/base'

class App < Sinatra::Application
  def initialize(app = nil)
    super()
  end

  get '/' do
    'Welcome'
  end
end