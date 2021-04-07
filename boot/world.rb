# frozen_string_literal: true
App.boot(:world) { start { Dir[App.config.root.join("world", "**", "*.rb")].sort.each { |file| require file } } }
