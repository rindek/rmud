# -*- encoding : utf-8 -*-
module Modules
  class Direction
    attr_accessor :short, :long
    
    SHORT       = 0
    LONG        = 1
    DEPOLONIZED = 2
        
    def initialize(direction)
      @connections = [
        ['n', 'północ'],
        ['ne', 'północny-wschód'],
        ['e', 'wschód'],
        ['se', 'południowy-wschód'],
        ['s', 'południe'],
        ['sw', 'południowy-zachód'],
        ['w', 'zachód'],
        ['nw', 'północny-zachód'],
        ['u', 'góra'],
        ['d', 'dół']
      ]

      update_connections
      
      find_short_direction(direction)
      find_long_direction(direction)
    end
    
    def update_connections
      (@connections.size).times do |i|
        @connections[i - 1] << @connections[i - 1][LONG].depolonize
      end
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
