require './boot'
require './core/server'

Rmud::Server.start!
Kernel.exec("ruby server.rb") if $reboot
