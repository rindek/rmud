# frozen_string_literal: true
module Models
  class Player < Sequel.Model(:players)
    include BCrypt

    def password
      values[:password] && Password.new(values[:password])
    end

    def password=(value)
      values[:password] = Password.create(value)
    end
  end
end
