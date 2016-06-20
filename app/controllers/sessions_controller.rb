require 'bcrypt'

class SessionsController < ApplicationController

  def new
  end

  def create

    users = User.find_by_sql "SELECT * FROM users WHERE email = '#{ActiveRecord::Base.sanitize params[:session][:email]}'"
    user = users[0]

    unless user.nil?

      userpass = BCrypt::Password.new user[:password_digest]

      if userpass == params[:session][:password]
        log_in user
        redirect_to '/recipes/my_recipes'
        return
      end
    end

    render 'new'

  end

  def destroy
    session.delete(:user_id)
  end

end
