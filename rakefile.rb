# frozen_string_literal: true

require 'sinatra/activerecord/rake'

namespace :db do
  task :load_config do
    require './app/server'
  end
end
