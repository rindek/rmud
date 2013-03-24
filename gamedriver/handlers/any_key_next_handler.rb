require_relative "next_handler"

class AnyKeyNextHandler < NextHandler
  def prompt
    "Wcisnij 'enter'..."
  end
  
  ## we do nothing here...
  def input(data)
    super(data)
  end
end
