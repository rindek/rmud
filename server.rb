require "./boot"
require "./core/server"

$boot_time = Time.now

server = Rmud::Server.new

Thread.new do
  begin
    EventMachine.run { server.start }
  rescue Exception => e
    Thread.main.raise(e)
  end
end

binding.pry

Kernel.exec("ruby server.rb") if $reboot
