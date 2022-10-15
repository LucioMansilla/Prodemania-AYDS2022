# frozen_string_literal: true

class PwRecovery < ActiveRecord::Base
  belongs_to :player, class_name: 'Player'
  validates_presence_of :player_id, :token
  validates_uniqueness_of :token, :player_id
end
