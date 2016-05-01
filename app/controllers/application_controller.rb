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

  def self.elastic_reindex
    selection = ActiveRecord::Base.connection.execute 'SELECT r.id, r.name, r.guide, avg(rr.quality) as avgquality,
                                                   avg(rr.difficulty) as avgdifficulty, avg(rr.time) as avgtime,
                                                   json_agg(i.name) as namearray, json_agg(c.amount) as amountarray,
                                                   json_agg(c.details) as detailsarray FROM recipes r
                                                   LEFT JOIN components c ON c.recipe_id = r.id
                                                   LEFT JOIN ingredients i ON i.id = c.ingredient_id
                                                   LEFT JOIN recipe_ratings rr ON r.id = rr.recipe_id
                                                   GROUP BY r.id, r.name, r.guide'

    selection.each do |row|
      $elastic.index index: 'homestaurant', type: 'complexrecipes', id: row['id'], body: row
    end
  end
  
end
