class RmudConnector < EventMachine::Connection
  attr_accessor :server

  ## connection
  def post_init
    p "new connection"
  end

  ## input
  def receive_data(data)
    p data
    # data = preprocess_input(data)

    # callback = proc { |r| @player_connection.input_handler.send_prompt }

    # EventMachine.defer(result, callback)
  end

  ## disconnection
  def unbind
    p "connection closed"
  end

  def preprocess_input(string)
    # combine CR+NULL into CR
    string = string.gsub(/#{CR}#{NULL}/no, CR)

    # combine EOL into "\n"
    string = string.gsub(/#{EOL}/no, "\n")

    string.gsub!(
      /#{IAC}(
        [#{IAC}#{AO}#{AYT}#{DM}#{IP}#{NOP}]|
        [#{DO}#{DONT}#{WILL}#{WONT}]
        [#{OPT_BINARY}-#{
        OPT_COMPRESS2
      }#{OPT_EXOPL}]|
        #{SB}[^#{IAC}]*#{IAC}#{SE}
        )/xno,
    ) do
      if IAC == $1
        # handle escaped IAC characters
        IAC
      elsif AYT == $1
        # respond to "IAC AYT" (are you there)
        send_data("nobody here but us pigeons" + EOL)
        ""
      elsif DO == $1[0, 1]
        # respond to "IAC DO x"
        send_data(IAC + WILL + OPT_BINARY) if OPT_BINARY == $1[1, 1]
        ""
      elsif DONT == $1[0, 1]
        # respond to "IAC DON'T x" with "IAC WON'T x"
        ""
      elsif WILL == $1[0, 1]
        # respond to "IAC WILL x"
        if OPT_BINARY == $1[1, 1]
          send_data(IAC + DO + OPT_BINARY)
        elsif OPT_ECHO == $1[1, 1]
          send_data(IAC + DO + OPT_ECHO)
        elsif OPT_SGA == $1[1, 1]
          send_data(IAC + DO + OPT_SGA)
        elsif OPT_COMPRESS2 == $1[1, 1]
          send_data(IAC + DONT + OPT_COMPRESS2)
        else
          send_data(IAC + DONT + $1[1..1])
        end
        ""
      elsif WONT == $1[0, 1]
        # respond to "IAC WON'T x"
        if OPT_ECHO == $1[1, 1]
          send_data(IAC + DONT + OPT_ECHO)
        elsif OPT_SGA == $1[1, 1]
          send_data(IAC + DONT + OPT_SGA)
        else
          send_data(IAC + DONT + $1[1..1])
        end
        ""
      else
        ""
      end
    end
    return string.chomp
  end
end
