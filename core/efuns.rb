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

class String
  def constantinize
    Object.module_eval(self)
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
    modules = self.to_s.split("::")
    if modules.first == "World"
      log_warning("Const missing: #{self.to_s}::#{name} - adding new constant")
      const_set(name, Module.new)
    else
      raise NameError, "uninitialized constant #{name}"
    end
  end
end

def load_file(file)
  require file.to_s if file.extname == ".rb"
end

def load_dir_recursive(dir)
  dir.each_child do |p|
    p.directory? ? load_dir_recursive(p) : load_file(p)
  end
end

def load_world
  world_dir = Pathname(Rmud.world)
  load_dir_recursive world_dir
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

def GameObject(name, parent_class, &block)
  file = CallChain.parse_caller(caller(1, 1).first).first
  patt = Regexp.new("(\\A#{Rmud.root}|.rb\\z)")
  file.gsub! patt, ''

  name = %{
    def __name__
      "#{gamepath(file)}"
    end
  }

  name += %q{
    def inspect
      "<#{__name__}##{object_id.to_s(32)}>"
    end
  }

  puts name
  klass = Class.new
  klass.class_eval(name)
  klass.class_eval &block
  register! gamepath(file), klass
end

def gamepath(path)
  path.split("/").reject(&:empty?).join(".")
end

$klasses = {}

def register! path, klass
  $klasses[path] = klass
end
