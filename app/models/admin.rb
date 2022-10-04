# frozen_string_literal: true

class Admin < ActiveRecord::Base
  include ActiveModel::Validations
  validates_presence_of :name, :email, :password
  validates_uniqueness_of :name, :email
  validates :name, length: { maximum: 20 }
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }
end
