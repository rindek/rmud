Pry.config.editor = 'vim'
require './boot.rb'
require './core/server'

Engine.instance.load_all
