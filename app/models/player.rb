class Player < ActiveRecord::Base
  
    has_many :forecasts 
    has_many :points 
    has_many :tournaments, through: :points

    validates_presence_of :name, :email, :password
    validates_uniqueness_of :name, :email
    validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }
    has_secure_password
    
  end