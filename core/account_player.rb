require './core/modules/declension'

class AccountPlayer
  include Declension

  attr_accessor :name

  DIR = "/players/"

  @name = nil
  @account_name = nil

  def initialize(account_name)
    @account_name = account_name
    init_declension()
  end

  def name= (name)
    @name = name
  end

  def account
    Engine.instance.accounts.select {|acc| acc.name == @account_name}.first
  end

  def save
    letter = @name[0..0]
    directory = Dir.pwd + AccountPlayer::DIR + letter + "/"
    begin
      Dir.entries(directory)
    rescue Exception => e
      begin
        Dir.mkdir(directory)
      rescue Exception => e
        puts "fatal error: cannot mkdir " + directory
      end
    end
    playerfile = directory + @name + ".yaml"
    File.open(playerfile, "w") do |f|
      YAML::dump(self, f)
    end

    playerfile
  end

end

