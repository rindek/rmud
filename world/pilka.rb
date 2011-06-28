require 'core/base_object'

module World
  class Pilka < BaseObject
    def initialize
      super()

      @short = "pilka"

			add_object_action(:podrzuc, "podrzuc")
    end

		def podrzuc(command)
			## zeby moc podrzucic pilke musi ona znajdowac się w jakimś environmencie
			return false if self.environment.nil?

			## environment musi być livingiem
			return false if !self.environment.is_a?(Living)

			## jeżeli env jest graczem, wtedy wyświetlamy mu info
			if self.environment.is_a?(Player)
				#self.environment.catch_msg("Podrzucasz pilke i lapiesz ja z powrotem.\n")
				this_player.catch_msg("Podrzucasz pilke i lapiesz ja z powrotem.\n")
			end

			## wyświetlamy info graczom
			this_player.environment.filter(Player, [this_player]).each do |p|
				p.catch_msg(this_player.short + " podrzuca pilke.\n")
			end

			## zwracamy true - komenda zakończona sukcesem
			return true
		end
  end
end