# frozen_string_literal: true
module Entities
  module DB
    class Base < Abstract
      attribute :_id, Types::BSON

      def id
        String(_id)
      end
    end
  end
end
