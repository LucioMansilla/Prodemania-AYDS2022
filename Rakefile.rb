require "sinatra/activerecord/rake"

namespace :db do
    task :load_config do
      require "./app/controllers/server"
    end
  end
