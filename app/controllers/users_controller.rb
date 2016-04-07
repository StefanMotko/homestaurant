class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    extparams = params[:user]

    if extparams[:password] != extparams[:password_confirmation]
      render 'new'
    end

    execute_sql "INSERT INTO users (username, email, password, created_at, updated_at)
                VALUES ('#{extparams[:username]}','#{extparams[:email]}','#{extparams[:password]}',timestamptz '#{Time.now}',timestamptz '#{Time.now}')"
    render nothing: true
  end

end
