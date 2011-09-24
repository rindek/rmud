class ConsoleCommand
  def initialize(string)
    @command = string.split(" ")
  end
  
  def cmd
    @command.size > 0 ? @command.first : ''
  end
  
  def has_args?
    @command.size > 1
  end
  
  def args
    @command.size > 1 ? @command[1..@command.length] : []
  end
end


def read_console(prompt = "[console] ")
  print prompt
  line = gets.chomp
  line
end
