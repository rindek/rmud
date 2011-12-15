module Modules
  module Props
    def prop(name, val = nil, force_nil = false)
      if val.nil? && !force_nil
        (@props ||= {})[name]
      elsif val.nil? && force_nil
        (@props ||= {})[name] = nil
      else
        (@props ||= {})[name] = val
      end
    end

    def props
      @props ||= {}
    end
  end
end