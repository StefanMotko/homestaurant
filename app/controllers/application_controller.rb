class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include SessionsHelper

  def execute_sql(sql)
    ActiveRecord::Base.connection.execute sql
  end

  def insert_via_sql(table, value_hash)

    columns = ''
    values = ''

    value_hash.each do |pair|
      columns += pair.first + ','
      values += ActiveRecord::Base.sanitize pair.last + ','
    end

    columns = columns[0..-2]
    values = values[0..-2]

    sql_string = "INSERT INTO #{table} (#{columns}) values (#{values})"
    ActiveRecord::Base.connection.execute sql_string
  end

  def delete_via_sql(table, condition)
    sql_string = "DELETE FROM #{table} WHERE #{condition}"
    ActiveRecord::Base.connection.execute sql_string
  end

  def edit_via_sql(table, value_hash, condition)
  end
  
end
