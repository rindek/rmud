class Event
  @@events = {}

  def self.get_events
    @@events
  end

  def self.fire(event_name, *args)
    log("Odpalam event '" + event_name + "' na obiekcie '" + args[0].class.to_s + "'")
#    args.each do |a|
#      p a
#    end
#
    unless @@events[event_name].nil?
      obj = args[0]


#      @@events[event_name].call(*args)
      unless @@events[event_name][obj].nil?
        @@events[event_name][obj]['events'].each do |event|
          event.call(*args)
        end
      end
    end
  end

#  def self.register(event_name, &block)
#    @@events[event_name] = block
#  end

#  def self.hook(event_name, *args, &block)
#    @@events[event_name]['']
#  end

  def self.hook(obj, event_name, &block)
    if @@events[event_name].nil?
      @@events[event_name] = {}
    end

    if @@events[event_name][obj].nil?
      @@events[event_name][obj] = {}
      @@events[event_name][obj]['events'] = []
    end

    @@events[event_name][obj]['events'] << block
  end
end
