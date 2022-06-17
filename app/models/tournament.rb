class Tournament < ActiveRecord::Base
    has_and_belongs_to_many :teams
    has_many :players, through: :points
    has_many :points
    has_many :match_days, dependent: :destroy
    has_many :forecasts

    validates_uniqueness_of :name
    validates :name, presence: true

    def self.all_tournament 
        Tournament.all
    end
end
