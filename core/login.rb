require 'singleton'
require 'digest/sha1'

require './core/engine.rb'
require './core/account.rb'

class Login
  include Singleton

  def login(user)
    set_environment("login")
    while !user.logged_in?
      command = Engine.instance.read(user, "Podaj swoje imie: ")
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
          password = Engine.instance.read(user, "Podaj haslo na konto: ")
          user.catch_msg("\n")
          if acc['password'] != Digest::SHA1.hexdigest(password.cmd)
            user.catch_msg("Bledne haslo! Zaloguj sie ponownie. Do zobaczenia.\n")
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
          user.catch_msg("Postac o takim imieniu nie istnieje. Sprobuj ponownie.\n")
        else
#          account = @model_account.get_by_player_id(player['id'])
          account = player.account

          user.dont_echo
          password = Engine.instance.read(user, "Witaj, #{player['name']}. Podaj swoje haslo: ")
          user.catch_msg("\n")
          if account['player_password'] != Digest::SHA1.hexdigest(password.cmd)
            user.catch_msg("Bledne haslo! Zaloguj sie ponownie. Do zobaczenia.\n")
            user.disconnect
            break
          else
            return player
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
