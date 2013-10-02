class BaseHandler
  attr_accessor :player

  def initialize(player: player)
    self.player = player
    self.player.input_handler = self
  end

  def send_prompt
    o(prompt)
  end
  
  ## default prompt to show user (can be overriden by sub-classes)
  def prompt
    "> "
  end
  
  def check_commands(commands, data, handler)
    cmd = data.to_c
  
    if @@commands.include?(cmd.to_sym)
      handler.send(cmd.to_sym, cmd.args)
    else
      oo("Nie ma takiej komendy, sprobuj ponownie.")
    end
  end
  
  def echo_off
    o([IAC, WILL, OPT_ECHO])
  end
  
  def echo_on
    o([IAC, WONT, OPT_ECHO])
  end
  
  ## shortcut for output for player
  def o(msg = "")
    msg = msg.is_a?(Array) ? msg : [msg]
    
    msg.each do |m|
      player.print(m)
    end
  end
  
  def oo(msg = "")
    player.println(msg)
  end

  def selfclass
    (class << self; self; end)
  end

  def handle_command_or(data)
    command = data.to_c
    method = "__#{command.to_s}"
    if respond_to?(method)
      send(method, command.args)
    else
      yield
    end
  end

  def change_handler handler_class
    handler_obj = handler_class.new player: self.player
    yield(handler_obj) if block_given?
  end
end
