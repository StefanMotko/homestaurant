class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    render nothing: true
  end

end
