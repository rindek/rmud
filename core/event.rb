class Event
  @@events = {}

  def self.fire(event_name, *args)
#    log("Odpalam event '" + event_name + "' z argumentami: ")
#    args.each do |a|
#      p a
#    end
#
    unless @@events[event_name].nil?
      @@events[event_name].call(*args)
    end
  end

  def self.register(event_name, &block)
    @@events[event_name] = block
  end

#  def self.hook(event_name, *args, &block)
#    @@events[event_name]['']
#  end
end
