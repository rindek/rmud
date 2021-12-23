# frozen_string_literal: true
module Traits
  module Emote
    def start_events_timer
      Concurrent::TimerTask
        .new(execution_interval: rand * 5) do |task|
          Engine::Events::Emote.call(who: self, what: events.sample, where: current_environment)
          task.execution_interval = rand * 5 + rand * 5
        end
        .execute
    end
  end
end
