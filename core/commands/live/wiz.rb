require 'singleton'
require './core/modules/command'

module Cmd
  module Live
    class Wiz
      include Singleton
      include Modules::Command

      def shutdown(command, this_player)
        shall_i_restart(false)
        p "Server shutdown executed in-game"
        EventMachine::stop_event_loop
      end

      def reboot(command, this_player)
        p "Server reboot, executed in-game"
        EventMachine::stop_event_loop
      end

      def load(command, tp)
        unless command.has_args?
          tp.fail_message = "load [file]?"
          return false
        end

        files = []
        command.args.each do |arg|
          files << "#{tp.prop(:current_path)}/#{arg}"
        end

        files.each do |file|
          tp.catch_msg("Trying to load "+ file + "... ")

          if File.exist?(file)
            if File.file?(file)
              ## make it simplier, plz...
              sp = file.gsub(/#{RMUD_ROOT}/, '').split("/")
              filename = sp.pop
              if sp.first == "world"
                sp = sp.map(&:capitalize).join("::")
                filename = filename[0..filename.length - 4]
                filename = filename.capitalize
                sp = sp.constantinize
                if sp.send(:const_defined?, filename.to_sym)
                  log_notice("[wiz::load] - removing constant #{sp.to_s}::#{filename}")
                  sp.send(:remove_const, filename.to_sym)
                end
              end

              super(file)
              tp.catch_msg("loaded!\n")
            else
              tp.catch_msg("fail! (file is a directory)\n")
            end
          else
            tp.catch_msg("fail! (file not found)\n")
          end
        end

        return true
      end

      def cd(command, tp)
        unless command.has_args?
          tp.prop(:current_path, RMUD_ROOT)
          tp.catch_msg(tp.prop(:current_path), true)
        else
          old = Dir.pwd
          Dir.chdir(tp.prop(:current_path))

          begin
            Dir.chdir(command.args[0])
            tp.prop(:current_path, Dir.pwd)
            Dir.chdir(old)
          rescue Errno::ENOENT => e
            tp.catch_msg("#{e.message}", true)
          end

          tp.catch_msg(tp.prop(:current_path), true)
        end
      end

      def ls(command, this_player)
        dir = this_player.prop(:current_path)
        this_player.catch_msg(dir + "\n")

        entries = Dir.entries(dir)
        entries.map! do |f|
          file = "#{dir}/#{f}"

          if File.file?(file) && File.extname(file) == ".rb"
            f = f.colorize(:cyan)
          elsif File.directory?(file)
            f = f.colorize(:green)
          end

          if File.is_loaded?(dir + "/" + f)
            f += "*"
          else
            f
          end
        end

        this_player.catch_msg(entries.join("  "))
        this_player.catch_msg("\n")
      end

      def cat(command, tp)
        dir = tp.prop(:current_path)
        unless command.has_args?
          tp.fail_message = "cat [file]"
          return false
        end

        file = "#{dir}/#{command.args[0]}"
        if File.exist?(file) && File.file?(file)
          data = ''
          f = File.open(file, "r")
          f.each_line do |line|
            data += line
          end
          if File.extname(file) == ".rb"
            data = CodeRay.scan(data, :ruby).term
          elsif File.extname(file) == ".yaml"
            data = CodeRay.scan(data, :yaml).term
          end
          tp.catch_msg(data, true)
        else
          tp.catch_msg("No such file: #{file}", true)
        end
      end

      def pry(command, tp)
        Thread.new do
          binding.pry
        end.join
      end

      def exec(command, tp)
        exec_str = command.args.join(" ")
        begin
          tp.catch_msg("----------------------------\n")
          tp.catch_msg("Executing: #{exec_str}\n")
          tp.catch_msg("----------------------------\n")
          tp.catch_msg(eval(exec_str))
          tp.catch_msg("\n")
          tp.catch_msg("----------------------------\n")
        rescue Exception => e
          tp.catch_msg("Error: #{$!}\n")
          e.backtrace.each do |msg|
            tp.catch_msg("#{msg}\n")
          end
        end
      end

      def init(player)
        init_module_command
        player.prop(:current_path, RMUD_ROOT)


        add_object_action(:load, "load")
        add_object_action(:ls, "ls")
        add_object_action(:cd, "cd")
        add_object_action(:cat, "cat")
        add_object_action(:pry, "pry")
        add_object_action(:exec, "exec")

        add_object_action(:shutdown, "shutdown")
        add_object_action(:reboot, "reboot")
      end
    end
  end
end
