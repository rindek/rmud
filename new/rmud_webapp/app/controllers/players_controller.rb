class PlayersController < ApplicationController
  before_filter :authenticate_account!

  def new
    @player = Player.new
    @player.build_dictionary
  end

  def create
    d = Dictionary.create(params[:player][:dictionary])
    if d
      p = Player.new(params[:player].except(:dictionary))
      p.dictionary = d
      p.account = current_account
      p.save
      redirect_to :root
    end
  end
end
