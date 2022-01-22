# frozen_string_literal: true
App.boot(:server) do |app|
  start do
    use :requirements
    app[:loader].eager_load

    ## database indices - find a better place to handle these
    app[:mongo][:dictionary].indexes.create_one({ "pojedyncza.mianownik": 1 }, unique: true)
    app[:mongo][:dictionary].indexes.create_one({ "nazwa": 1 }, unique: true)

    ## Load dictionary
    Engine::Lib::DictionaryLoader.new.load!

    ## Load all world
    use :world

    Thread.new do
      EventMachine.run do
        EventMachine.start_server App[:settings].host, App[:settings].port, Engine::Server
        puts "Now accepting connections on address #{App[:settings].host} port #{App[:settings].port}..."
      end
    end
  end
end
