class MatchDay < ActiveRecord::Base 
  belongs_to :tournament
  has_many :matches

  validates :description, presence: true
end