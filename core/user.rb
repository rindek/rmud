class User
  attr_accessor :nick, :port, :logged_in

  @connection = nil

  def initialize(conn)
    @connection = conn
    @nick = ""
    @port = conn.peeraddr[1]

    puts conn.peeraddr.inspect

    @logged_in = false
  end

  def self.current
    @connection
  end

  def logged_in?
    @logged_in
  end

  def connected?
    !socket.closed?
  end

  def disconnect()
    socket.close
  end

  def catch_msg(msg)
    write_socket(msg)
  end

  def write_socket(msg)
    begin
      @connection.write(msg)
      @connection.flush
    rescue IOError => e
      puts "Connection lost!"
    end
  end

  def dont_echo
    socket.print 0xff.chr # IAC
    socket.print 0xfb.chr # WILL
    socket.print 0x01.chr # ECHO
  end

  def get
    @connection
  end

  def socket
    @connection
  end

  def get_connection
    @connection
  end
end