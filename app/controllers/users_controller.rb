require 'bcrypt'

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

  def edit

  end

  def modify
    user = (User.find_by_sql "SELECT * FROM users WHERE id=#{current_user[:id]}")[0]
    userpass = BCrypt::Password.new(user[:password_digest])

    if userpass == params[:useredit][:oldpass] and params[:useredit][:password] == params[:useredit][:password_confirmation]
      newpass = BCrypt::Password.create(params[:useredit][:password])

      execute_sql "UPDATE users SET password_digest='#{newpass}' WHERE id=#{current_user[:id]}"
      redirect_to '/'
      return
    end

    render 'edit'

  end

end