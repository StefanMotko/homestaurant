module SessionsHelper

  def log_in(user)
    session[:user_id] = user.id
  end

  def current_user
    if @current_user.nil? and not session[:user_id].nil?
      users = User.find_by_sql "SELECT * FROM users WHERE id = #{session[:user_id]}"
      @current_user = users[0]
    end
    @current_user
  end

  def logged_in
    !current_user.nil?
  end

end
