require './boot'
require './core/engine'

Engine.instance.load_all


def autolog
  true
end

EventMachine::run do
  load_world ## :-(

  server_config = read_config("game")[Rmud.env]
  log_notice("[server.rb] - accepting connections on #{server_config["host"]}:#{server_config["port"]}")

  Callbacks.execute(:before_server_start)

  EventMachine::start_server server_config["host"], server_config["port"], RmudConnector
end

Kernel.exec("ruby server.rb") if $reboot

