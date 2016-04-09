class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create

    extparams = params.require(:user).permit(:username,:email,:password,:password_confirmation)
    @user = User.new(extparams)


    if @user.invalid?
      render 'new'
      return
    end

    execute_sql "INSERT INTO users (username, email, password_digest, created_at, updated_at)
                VALUES ('#{@user.username}','#{@user.email}','#{@user.password_digest}',timestamptz '#{Time.now}',timestamptz '#{Time.now}')"
    render 'sessions/new'
  end

end