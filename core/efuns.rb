# -*- encoding : utf-8 -*-
RMUD_ROOT = Dir.pwd


def shall_i_restart(val)
  Thread.current[:restart_request] = val
end

def shall_i_restart?
  Thread.current[:restart_request]
end

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
  line = "[" + Time.now.strftime("%Y-%m-%d %H:%M:%S") + "] " + str + "\n"
  puts line
end

def log_colored(str, color=nil)
  line = "[" + Time.now.strftime("%Y-%m-%d %H:%M:%S") + "] " + str
  unless color.nil?
    line = line.colorize(color)
  end
  
  line += "\n"
  puts line
end

def log_error(str)
  log_colored("ERROR: "+ str, :red)
end

def log_warning(str)
  log_colored("WARNING: "+ str, :yellow)
end

def log_notice(str)
  log_colored(str, :green)
end

## config
def read_config(config_name)
  YAML.load_file("gamedriver/config/"+ config_name +".yaml")
end

def object_clones(modulename)
  begin
    if modulename.class == String
      modulename = modulename.constantinize
    end

    ObjectSpace.each_object(modulename).to_a
  rescue Exception => e
    log_warning("Not loaded: " + modulename.to_s)
  end
end

class Object
  @@loaded_files = []

  def require(path)
    if super(path)
      log_notice("Required: " + path)
      unless @@loaded_files.include?(path)
        @@loaded_files << path
      end
    end
  end

  def load(path)
    if super(path)
      log_notice("Loaded: " + path)
      unless @@loaded_files.include?(path)
        @@loaded_files << path
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

# class Module
#   def const_missing(name)
#     binding.pry
#   end
# end
# class Module
#   def const_missing(name)
#     binding.pry
#     modules = self.to_s.split("::")
#     if modules.first == "World"

#       curr_mod = ""
#       modules.each do |m|
#         if curr_mod == ""
#           curr_mod = m
#         else
#           curr_mod = "#{curr_mod}::#{m}"
#         end
#         Object.const_set(name, Module.new)
#       end
#       binding.pry

#       modules << name.to_s
#       filename = "./" + modules.map(&:downcase).join("/")
#       require filename
#       if const_get(name)
#         return modules.join("::").constantinize
#       end
#     else
#       raise "uninitialized constant #{name}"
#     end
#   end
# end

class String
  def constantinize
    Object.module_eval(self)
  end
  
  def depolonize_string(str)
    str.gsub!(/ą/, "a")
    str.gsub!(/ć/, "c")
    str.gsub!(/ł/, "l")
    str.gsub!(/ń/, "n")
    str.gsub!(/ó/, "o")
    str.gsub!(/ś/, "s")
    str.gsub!(/ź/, "z")
    str.gsub!(/ż/, "z")
    
    str
  end
  
  def depolonize
    str = self.clone
    depolonize_string(str)
  end
  
  def depolonize!
    depolonize_string(self)
  end

  def respond_to_command?(*args)
    log_notice("[string::respond_to_command] - ???? #{args.to_s}")
    false
  end
end

class CallChain
  def self.caller_method(depth=1)
    parse_caller(caller(depth+1).first).last
  end

  #Stolen from ActionMailer, where this was used but was not made reusable
  def self.parse_caller(at)
    if /^(.+?):(\d+)(?::in `(.*)')?/ =~ at
      file   = Regexp.last_match[1]
      line   = Regexp.last_match[2].to_i
      method = Regexp.last_match[3]
      [file, line, method]
    end
  end
end

def game_path(klass)
  modules = klass.split("::")
  "/" + modules.map(&:downcase).join("/")
end

class Module
  def const_missing(name)
    log_warning("const missing: #{self.to_s + "::" + name.to_s} - trying to load/generate...")
    modules = self.to_s.split("::")
    if modules.first == "World"
      modules << name.to_s

      filename = RMUD_ROOT + "/" + modules.map(&:downcase).join("/")

      # binding.pry
      if File.exists?(filename + ".rb") && File.file?(filename + ".rb")
        load_file_using_eval(filename + ".rb")
      elsif File.exists?(filename) && File.directory?(filename)
        generate_empty_module(filename)
      end

      if const_get(name)
        return modules.join("::").constantinize
      end
    else
      raise "uninitialized constant #{name}"
    end
  end
end

def generate_empty_module(filename)
  d = filename.gsub(RMUD_ROOT + "/", "")
  modules = d.split("/")

  evaled = ""
  modules.each {|m| evaled << "module #{m.capitalize} "}
  modules.each {|m| evaled << "end; "}

  eval(evaled)
  log_notice("[code] - module #{modules.map(&:capitalize).join("::")} generated")
end

# def load_file_using_eval(filename)
#   d = filename.gsub(RMUD_ROOT + "/", "")
#   modules = d.split("/")
#   file = modules.pop

#   evaled = ""
#   modules.each do |m|
#     evaled << "module #{m.capitalize} "
#   end
#   evaled << File.read(filename) + "\n"
#   modules.each do
#     evaled << "end\n"
#   end

#   begin
#     eval(evaled)
#     log_notice("[core] - load_file_using_eval- loaded file #{filename}")
#   rescue SyntaxError => e
#     log_error("[core] - load_file_using_eval - failed to load file #{filename} due to syntax error")
#     log_error("[code] - load_file_using_eval - #{e.message}")
#   rescue Exception => e
#     log_error("[core] - load_file_using_eval - failed to load file #{filename} due to FATAL error")
#     log_error("[code] - load_file_using_eval - #{e.message}")
#   end
# end

def load_file(filename)
  log_notice("[core] - load file - loading file #{filename}")
  require filename
end

def load_world_recursive(dir)
  Dir.entries(dir).each do |file|
    if file.match(/.+rb/)
      load_file(dir + file)
    else
      if file != "." && file != ".." && File.directory?(dir + file)
        load_world_recursive(dir + file + "/")
      end
    end
  end
end

def load_world
  world_dir = RMUD_ROOT + "/world/"
  load_world_recursive(world_dir)
end

# def game_path_to_constant_string path
#   path.split("/").map(&:capitalize).join("::")
# end

def before_start
  $boot_time = Time.now
end

module World
end

def current_namespace(lvl=0)
  file = CallChain.parse_caller(caller.first).first
  file.gsub!(/#{Dir.pwd}/, '')
  file = file.split("/")

  filename = file.pop

  lvl.times { file.pop }

  file.map(&:capitalize).join("::").constantinize
end


def time2hash(f)
  i = f.to_i

  years = i / 1.years
  i -= years.years
  months = i / 1.months
  i -= months.months
  days = i / 1.days
  i -= days.days
  hours = i / 1.hours
  i -= hours.hours
  minutes = i / 1.minutes
  i -= minutes.minutes
  seconds = i

  {years: years, months: months, days: days, 
    hours: hours, minutes: minutes, seconds: seconds}
end

def time2str(f, precision = :years)
  hash = time2hash(f)

  if precision == :years
    str = "#{hash[:years]} y #{hash[:months]} mo #{hash[:days]} d #{hash[:hours]} h #{hash[:minutes]} m #{hash[:seconds]} s"
  elsif precision == :months
    hash[:months] += hash[:years] * 12

    str = "#{hash[:months]} mo #{hash[:days]} d #{hash[:hours]} h #{hash[:minutes]} m #{hash[:seconds]} s"
  elsif precision == :days
    hash[:months] += hash[:years] * 12
    hash[:days] += hash[:months] * 30

    str = "#{hash[:days]} d #{hash[:hours]} h #{hash[:minutes]} m #{hash[:seconds]} s"
  elsif precision == :hours
    hash[:months] += hash[:years] * 12
    hash[:days] += hash[:months] * 30
    hash[:hours] += hash[:days] * 24

    str = "#{hash[:hours]} h #{hash[:minutes]} m #{hash[:seconds]} s"
  elsif precision == :minutes
    hash[:months] += hash[:years] * 12
    hash[:days] += hash[:months] * 30
    hash[:hours] += hash[:days] * 24
    hash[:minutes] += hash[:hours] * 60

    str = "#{hash[:minutes]} m #{hash[:seconds]} s"
  elsif precision == :seconds
    hash[:months] += hash[:years] * 12
    hash[:days] += hash[:months] * 30
    hash[:hours] += hash[:days] * 24
    hash[:minutes] += hash[:hours] * 60
    hash[:seconds] += hash[:minutes] * 60

    str = "#{hash[:seconds]} s"
  else
    hash[:months] += hash[:years] * 12
    hash[:days] += hash[:months] * 30

    str = "#{hash[:days]} d #{hash[:hours]} h #{hash[:minutes]} m #{hash[:seconds]} s"
  end


  str
end

class Fixnum
  def minutes
    self * 60
  end

  def hours
    self * 60.minutes
  end

  def days
    self * 24.hours
  end

  def months
    self * 30.days
  end

  def years
    self * 12.months
  end
end


class Hash
  def softmerge(other_hash)
    self.keys.each do |key|
      self[key] = other_hash[key] unless other_hash[key].nil?
    end
  end
end

def unload obj, const
  if obj.send(:const_defined?, const)
    log_notice("[efun::unload] - removing constant #{obj.to_s}::#{const}")
    obj.send(:remove_const, const)
  end
end
