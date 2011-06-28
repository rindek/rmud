require 'core/living.rb'

class Player < Living

  attr_accessor :commands

  def initialize(user, player)
    super()

    @player = nil
#    @commands = {}
		@souls = []

#    add_action("zakoncz") do |*args|
 #     p args
 #     catch_msg("zakanczamy!\n")
 #   end

    set_user(user)
    set_player(player)

    set_this_player(self)

    @souls << Cmd::Live::Standard.instance
    @souls << Cmd::Live::Exits.instance
    @souls << Cmd::Live::Wiz.instance

		## aby zainicjalizować komendy
		update_hooks
  end

  def set_user(user)
    @user = user
  end

  def set_player(player)
    @player = player
    @short = @player['name']
  end

  def is_player?
    true
  end

	def update_hooks
		@souls.each do |soul|
			soul.init
		end
	end

	def get_souls
		@souls
	end

	## wywołanie komendy na graczu
	def command(str)
		cmd = Command.new(str)
		Engine.instance.serve(self, cmd)
	end

  def socket
    @user.socket
  end

  def catch_msg(msg)
    @user.catch_msg(msg)
  end

  def disconnect()
    @user.disconnect()
  end

  def remove()
    super()

    disconnect()
  end
end
