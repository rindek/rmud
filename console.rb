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
      begin
        ConsoleCommands.send(command.cmd, command.args)
      rescue SystemExit => e
        puts "Quitting..."
        ## breaking loop to exit process 
        break
      rescue Exception => e
        message  = "#=================================\n"
        message += "# Error: #{$!}\n"
        message += "#=================================\n"
        e.backtrace.each do |msg|
          message += "# " + msg + "\n"
        end
        message += "#=================================\n"

        log_error("\n" + message) # na serwer
        false
      end
    else
      log_error("[console] - there is no such command for console '#{command.cmd.to_s}'")
      log_error("[console] - type in 'help' to see list of available commands")
    end
  end
end
