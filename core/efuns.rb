def current_environment
  Thread.current[:environment]
end

def set_environment(envi)
  Thread.current[:environment] = envi
end

def current_user
  Thread.current[:user]
end

def set_current_user(user)
  Thread.current[:user] = user
end

def current_connection
  Thread.current[:user].socket unless Thread.current[:user].nil?
end

def load_player(player_name)
  Engine.instance.load_player(player_name)
end

def set_this_player(player)
  Thread.current[:player] = player
end

def this_player
  Thread.current[:player]
end

def add_action(s_method, verb)
  this_player.commands[verb] = method(s_method)
end

## setter
def fail_message(message)
  Thread.current[:fail_message] = message
end

def get_fail_message
  Thread.current[:fail_message]
end

def log(str)
  puts "[" + Time.now.strftime("%Y-%m-%d %H:%M:%S") + "] " + str + "\n"
end

## config
def read_config(config_name)
  YAML.load_file("config/"+ config_name +".yaml")
end

class Object
  def require(path)
    if super(path)
      log("Loaded: " + path)
    end
  end
end


