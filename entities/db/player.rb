# frozen_string_literal: true
module Entities
  module DB
    class Player < Base
      attribute :name, Types::String
      attribute :password, Types::String
    end
  end
end
