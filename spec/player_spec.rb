# frozen_string_literal: true

require_relative '../app/models/init'

#  #Task: 183187326-
#     Si se intenta registrar un usuario ya existente - retornar el error correspondiente y hacer un rollback de la operación.
#
#     Si se intenta registrar un usuario con nombres inválidos - retornar el error correspondiente y hacer un rollback de la operación.
#
#     Si se intenta registrar un usuario con formato inválido de contraseña - retornar el error correspondiente y hacer un rollback de la operación.

user = Player.new(name: 'Lucio', email: 'lucio@correo.com', password: '12345', is_admin: true)

describe 'Player' do
  describe 'when trying to register an existing user' do
    it 'should return error when user already exists' do
      user_repeated = Player.new(name: 'Lucio', email: 'lucio@correo.com', password: '12345', is_admin: true)
      expect(user.save).to eq(false)
    end
  end

  describe 'when a user tries to register with invalid names' do
    it 'should return false' do
      user_invalid_name = Player.new(name: 'L', email: 'lucio@correo.com', password: '12345', is_admin: true)
      expect(user.save).to eq(false)
    end
  end

  describe 'when a user is registered with an invalid password format' do
    it 'should return false' do
      user_invalid_password = Player.new(name: 'Lucio', email: 'lucio@correo.com', password: 'short',
                                         is_admin: true)
      expect(user.save).to eq(false)
    end
  end
end
