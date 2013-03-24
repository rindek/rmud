Mongoid.load!(Rmud.root + "/gamedriver/config/mongoid.yml", Rmud.env)

Moped.logger = Logger.new($stdout)
Mongoid.logger = Logger.new($stdout)

Moped.logger.level = Logger::DEBUG
Mongoid.logger.level = Logger::DEBUG

Mongoid.raise_not_found_error = false
