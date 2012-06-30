class AccountsController < ApplicationController
  before_filter :authenticate_account!

  def my

  end
end