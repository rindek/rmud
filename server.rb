require './boot'
require './core/server'

$boot_time = Time.now

server = Rmud::Server.new

Thread.new do
  EventMachine.run {
    server.start
  }
end

binding.pry

Kernel.exec("ruby server.rb") if $reboot
