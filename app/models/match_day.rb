class MatchDay < ActiveRecord::Base 
  belongs_to :tournament
  has_many :matches, dependent: :destroy

  validates :description, presence: true
end