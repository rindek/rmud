require_relative "efuns"
require 'singleton'
require './core/lang/pl'

class Engine
  include Singleton

  attr_accessor :accounts

  def initialize
    @accounts = []
  end

  ## ładujemy wszystkie pliki znajdujące się w ['core', 'gamedriver', 'mudlib']
  def load_all
    log_notice("[core] - Loading all files from " + ['core', 'gamedriver', 'mudlib'].join(", ") + " dirs")
    dirs = [Dir.pwd + "/core/", Dir.pwd + "/gamedriver/", Dir.pwd + "/mudlib/"]
    dirs.each do |subdir|
      load_dir_recursive(subdir)
    end
    log_notice("[core] - Finished loading all files")
  end
  
  ## przeladowujemy wszystkie pliki znajdujace sie w ['core', 'gamedriver', 'mudlib']
  def reload_all
    log_notice("[core] - Reloading all files from " + ['core', 'gamedriver', 'mudlib'].join(", ") + " dirs")
    dirs = [Dir.pwd + "/core/", Dir.pwd + "/gamedriver/", Dir.pwd + "/mudlib/"]
    dirs.each do |subdir|
      load_dir_recursive(subdir, true)
    end
    log_notice("[core] - Finished reloading all files")
  end
  
  def load_dir_recursive(dir, are_we_loading = false)
    Dir.entries(dir).sort.each do |file|
      if file.match(/.+.rb/)
        if are_we_loading
          load (dir + file)
        else
          require (dir + file)
        end
      else
        if file != "." && file != ".." && File.directory?(dir + file)
          load_dir_recursive(dir + file + "/", are_we_loading)
        end
      end
    end
  end
end
