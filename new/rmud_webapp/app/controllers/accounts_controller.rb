class AccountsController < ApplicationController
  before_filter :authenticate_account!

  def my
    @players = current_account.players
  end
end