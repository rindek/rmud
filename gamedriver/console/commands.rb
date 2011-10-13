require 'optparse'

class ConsoleCommands
  def self.help(args)
    puts "List of commands that you can use: "
    self.singleton_methods(false).each do |m|
      puts "* #{m.to_s}"
    end
  end
  
  def self.kill(args)
    puts "Trying to stop process: #{Runner.instance.child}"
    Process.kill("STOP", Runner.instance.child)
  end
  
  def self.pry(args)
    binding.pry
  end
  
  def self.daemon(args)
    Process.daemon(true)
  end
  
  ## start rmud
  def self.start(args)
    if Runner.instance.running?
      puts "Game is already running on port #{Runner.connector.port.to_s}" 
      return
    end
    
    unless Runner.instance.fork_and_run!
      puts "Couldn't launch game"
    end
  end
  
  ## stopping mud
  def self.stop(args)
    options = ConsoleCommandOptions.new({
      options: [
        [:force, "-f", "--force", "BRUTAL way to stop server. Data may be lost. Use it with caution"],
        [:confirm, '-y', '--yes', 'You need to use this option if you really want to stop MUD']
      ],
      banner: "Usage: stop [options]"
    }, args).parsed
    
    unless Runner.instance.running?
      puts "Game is not running, so you can't stop it, eh?"
      return
    end
    
    if options.empty?
      puts "Stop command needs and option, type 'stop -h' for more info"
      return
    end
    
    if options[:confirm]
      if options[:force]
        puts "Stopping server the BRUTAL WAY. It actually sends connector the stop signal. It should be used only when you can't stop it in any other way (for example game is stuck in infinite loop or something)"
        Runner.connector.stop
      else
        puts "Stopping server the NORMAL WAY. It sends signal to game to do all things before actual shutdown."
        Engine.instance.shutdown!
      end
    else
      puts "You need to confirm through --yes option to actually stop server"
    end
  end
  
  def self.quit(args)
    options = ConsoleCommandOptions.new({
      options: [
        [:yes, "-y", "--yes", "Quit console and send shutdown signal to game"],
        [:force, "-f", "--force", "Force quitting game without shutdown signal to game"]
      ],
      banner: "Usage: quit [options]"
    }, args).parsed
    
    if Runner.instance.running?
      puts "Game is currently running, if you really want to quit, use --yes option."
      puts "It will send a shutdown signal to game."
      puts "If you want to force-quit, use --force option, but be preapred for some data-loss"
    end
    
    if Runner.instance.running?
      if options[:yes] && options[:force]
        Process.exit
      elsif options[:yes] && options[:force].nil?
        Engine.instance.shutdown!
        Process.exit
      end
    else
      ## Game not running, we quit normally
      Process.exit
    end
  end
end

class ConsoleCommandOptions
  attr_reader :parsed
  
  def initialize(options, args)
    @parsed = {}
    
    parser = OptionParser.new do |opts|
      opts.banner = options[:banner]
      options[:options].each do |option|
        opts.on(option[1], option[2], option[3]) do |o|
          @parsed[option[0]] = o
        end
      end
      
      opts.on("-h", "--help", "Show this message") do |h|
        puts opts
      end
    end
    
    begin
      parser.parse(args)
    rescue Exception => e
      puts e.message
      puts "Type '#{CallChain.caller_method(4)} --help' to list all options"
    end
    self
  end
end

# require 'optparse'
# 
# options = {}
# parser = OptionParser.new do |opts|
#   opts.banner = "Usage: example.rb [options]"
# 
#   opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
#     options[:verbose] = v
#   end
# end
# 
# parser.parse("--no-verbose")
# 
# p options
# p ARGV
