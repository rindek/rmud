# this is fucking stupid, it seems that
# AnyKeyNextHandler DOESN'T extends NextHandler 
# NOR any other handlers :|
class AnyKeyNextHandler < NextHandler
  def prompt
    "Wcisnij 'enter'..."
  end
  
  ## we do nothing here...
  def input(data)
    super(data)
  end
end