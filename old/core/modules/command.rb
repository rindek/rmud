module Modules
  module Command
    def init_module_command
      @object_commands = {}
    end

    ## funkcja sprawdza, czy dany obiekt reaguje na wywołanie komendy
    def respond_to_command?(command)
      !@object_commands[command.cmd].nil?
    end

    ## pobiera metodę do wywołania
    def get_command(command)
      @object_commands[command.cmd]
    end

    ## dodaje (na podobnej zasadzie jak add_action) komendę możliwą do wywołania
    ## na tym obiekcie
    def add_object_action(s_method, verb)
      if s_method.is_a?(Method)
        @object_commands[verb] = s_method
      else
        @object_commands[verb] = method(s_method)
      end
    end
  end
end