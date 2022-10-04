# frozen_string_literal: true

class Point < ActiveRecord::Base
  belongs_to :tournament
  belongs_to :player
end
