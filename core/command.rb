# class Command
#   attr_accessor :cmd, :args, :args_array

#   def initialize(command)
#     if command.empty?
#       @cmd = command
#     else
#       @cmd = command.split(" ").shift
#     end

#     if command.split(" ").size > 1
#       @args_array = command.split(" ")[1..-1]
#       @args = @args_array.join(" ")
#     end
#   end

#   def has_args?
#     if @args.nil?
#       false
#     else
#       true
#     end
#   end

#   def to_s
#     @cmd + (" " + @args if @args).to_s
#   end
# end
