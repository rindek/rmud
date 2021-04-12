require "dry/system/container"
require "dry/events/publisher"

class App < Dry::System::Container
  use :env

  configure do
    config.env = ENV["STAGE"] || "development"
    config.root = Pathname.new(__dir__)
  end
end

class GameContainer
  extend Dry::Container::Mixin
  register(:rooms, Dry::Container.new)
  register(:items, Dry::Container.new)
end

class AppEvents
  include Dry::Events::Publisher[:app]
  register_event("players.room.entered")
  register_event("players.room.left")
end

App.register(:game, GameContainer)
App.register(:players, Concurrent::Hash.new)
App.register(:events, AppEvents.new)

Dir[App.config.root.join("boot", "**", "*.rb")].sort.each { |file| require file }

class EventListener
  def on_players_room_left(event)
    event[:from_room]
      .inventory
      .players(without: event[:player])
      .each do |pl|
        pl.write("%s podąża %s %s.\n" % [event[:player].name, event[:to_exit].joiner, event[:to_exit].name])
      end
  end

  def on_players_room_entered(event)
    event[:to_room]
      .inventory
      .players(without: event[:player])
      .each { |player| player.write("%s przybywa.\n" % [event[:player].name]) }
  end
end

App[:events].subscribe(EventListener.new)
