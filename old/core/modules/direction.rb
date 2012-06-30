# -*- encoding : utf-8 -*-
module Modules
  class Direction
    attr_accessor :short, :long
    
    DIRECTIONS_SHORT = ['n', 'ne', 'e', 'se', 's', 'sw', 'w', 'nw', 'u', 'd'] 
    DIRECTIONS_LONG = [
      'polnoc', 'polnocny-wschod', 'wschod', 
      'poludniowy-wschod', 'poludnie', 'poludniowy-zachod', 'zachod', 
      'polnocny-zachod', 'gora', 'dol'
    ]

    SHORT       = 0
    LONG        = 1
        
    def initialize(direction)
      @connections = []

      DIRECTIONS_SHORT.each_index do |i|
        @connections << [DIRECTIONS_SHORT[i], DIRECTIONS_LONG[i]]
      end

      find_short_direction(direction)
      find_long_direction(direction)
    end
    
    def find_short_direction(direction)
      @connections.each do |d|
        if d.include?(direction)
          @short = d[SHORT]
          break
        end
      end
    end
    
    def find_long_direction(direction)
      @connections.each do |d|
        if d.include?(direction)
          @long = d[LONG]
          break
        end
      end
    end
  end
end
