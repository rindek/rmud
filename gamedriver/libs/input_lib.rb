class InputLib
  def initialize(str)
    @cmd = str.split
  end
  
  def args
    @cmd[1..@cmd.size]
  end
  
  def has_args?
    args.length > 0
  end
  
  def cmd
    to_s
  end
  
  def to_s
    @cmd.first || ""
  end
  
  def to_sym
    to_s.to_sym
  end
end

## extending String class
class String
  def to_c
    InputLib.new(self)
  end
end