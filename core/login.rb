# coding: utf-8

require 'singleton'
require 'digest/sha1'

require './core/engine.rb'
require './core/account.rb'

class Login
  include Singleton

  def login(user)
    set_environment("login")
    while !user.logged_in?
      command = Engine.instance.read(user, "Podaj swoje imię: ")
      puts command.inspect
      if command.cmd == 'nowe' && (command.has_args? && command.args_array[0] == 'konto')
        acc = Account.new
        acc.create_new_user(user)
      elsif command.cmd == 'konto' && command.has_args?
        acc = find_account(command.args_array[0])
        if acc.nil?
          user.catch_msg("Nie ma takiego konta.\n")
        else
          #user.catch_msg("Znaleziono konto z imieniem: " + acc.name + "\n")
          # wylaczamy echo na te linijke
          # user.socket.print 0xff.chr
          # user.socket.print 0xfb.chr
          # user.socket.print 0x01.chr
          user.dont_echo
          password = Engine.instance.read(user, "Podaj hasło na konto: ")
          user.catch_msg("\n")
          if acc['password'] != Digest::SHA1.hexdigest(password.cmd)
            user.catch_msg("Błędne hasło! Zaloguj się ponownie. Do zobaczenia.\n")
            user.disconnect
            break
          else
            Account.new.manage(acc)
          end
        end
      elsif command.cmd == 'zakoncz'
        user.catch_msg("Do zobaczenia!\n")
        user.disconnect()
        break
      else
        @model_player = Models::Player.new
        @model_account = Models::Account.new

        player = @model_player.get_by_name(command.cmd)
        if player.nil?
          user.catch_msg("Postać o takim imieniu nie istnieje. Spróbuj ponownie.\n")
        else

          if !player['created']
            user.catch_msg("Ta postać nie jest do końca utworzona. Skorzystaj z opcji tworzenia postaci z poziomu konta, aby dokończyć kreację postaci.\n")
          else
            account = player.account

            user.dont_echo
            password = Engine.instance.read(user, "Witaj, #{player['name']}. Podaj swoje hasło: ")
            user.catch_msg("\n")
            if account['player_password'] != Digest::SHA1.hexdigest(password.cmd)
              user.catch_msg("Błędne haslo! Zaloguj się ponownie. Do zobaczenia.\n")
              user.disconnect
              break
            else
              return player
            end
          end
        end
      end
    end
  end

  def find_account(name)
    acc = Models::Account.new
    acc.get_by_name(name)
  end
end
