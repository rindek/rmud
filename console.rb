# coding: utf-8
require './boot.rb'
require './core/efuns.rb'

require './gamedriver/console/functions.rb'
require './gamedriver/console/commands.rb'
require './gamedriver/console/runner.rb'

if $0 == __FILE__
  loop do
    command = ConsoleCommand.new(read_console('[console] '))
    
    if ConsoleCommands.respond_to?(command.cmd)
      ConsoleCommands.send(command.cmd, command.args)
    else
      log_error("[console] - there is no such command for console '#{command.cmd.to_s}'")
      log_error("[console] - type in 'help' to see list of available commands")
    end
  end
end
