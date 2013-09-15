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
    dirs = [Dir.pwd + "/core/", Dir.pwd + "/gamedriver/", Dir.pwd + "/mudlib/"].map{|dir| Pathname(dir)}
    dirs.each do |subdir|
      load_dir_recursive(subdir)
    end
    log_notice("[core] - Finished loading all files")
  end
end
