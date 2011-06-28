def set_server_environment(envi)
  Thread.current[:server_environment] = envi
end

def server_environment
  Thread.current[:server_environment]
end

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
  @@loaded_files = []

  def require(path)
    if super(path)
      log("Loaded: " + path)
    end
  end

  def load(path)
    if super(path)
      unless @@loaded_files.include?(path)
        @@loaded_files << path
        p @@loaded_files
      end
    end
  end

  def loaded_files
    @@loaded_files
  end
end

class File
  def self.is_loaded?(path)
    @@loaded_files.include?(path)
  end
end
