# frozen_string_literal: true
module Traits
  module Emote
    def start_events_timer
      Concurrent::TimerTask
        .new(execution_interval: rand * 60) do |task|
          Engine::Events::Emote.call(who: self, what: events.sample, where: current_environment)
          task.execution_interval = rand * 60 + rand * 60
        end
        .execute
    end
  end
end
