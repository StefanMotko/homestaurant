class RecipesController < ApplicationController

  def my_recipes
    @pagecount = 0
    if current_user.nil?
      redirect_to '/login'
      return
    end

    all_recipes = Recipe.find_by_sql "SELECT name, id FROM recipes WHERE user_id = #{current_user[:id]}"
    page = Integer((params[:commit] ? params[:commit] : '1'))
    rangemin = page * 9 - 9
    rangemax = page * 9 - 1
    @itemlist = all_recipes[rangemin .. rangemax]
    @thumbtype = :recipe
    @pagecount = all_recipes.to_a.length / 9 + 1
  end

  def favorites
    @pagecount = 0
    if params[:query].nil?
      return
    end

    if params[:commit] == 'Search'
      params[:commit] = '1'
    end

    if params[:query][:text] == ''
      all_recipes = Recipe.find_by_sql 'SELECT name, id FROM recipes'
    else
      qstring = params[:query][:text]
      all_recipes = Recipe.find_by_sql "SELECT DISTINCT r.id, r.name FROM recipes r LEFT JOIN components c ON c.recipe_id = r.id LEFT JOIN ingredients i ON c.ingredient_id = i.id
                                        WHERE '#{qstring}' @@ r.name OR '#{qstring}' @@ r.guide OR '#{qstring}' @@ i.name OR '#{qstring}' @@ c.details"
    end

    page = Integer((params[:commit] ? params[:commit] : '1'))
    rangemin = page * 9 - 9
    rangemax = page * 9 - 1
    @itemlist = all_recipes[rangemin .. rangemax]
    @thumbtype = :recipe
    @query = params[:query][:text]
    @pagecount = all_recipes.to_a.length / 9 + 1
  end

  def browse

    @pagecount = 0
    if params[:query].nil?
      return
    end

    if params[:commit] == 'Search'
      params[:commit] = '1'
    end

    if params[:query][:text] == ''
      search = $elastic.search index: 'homestaurant', type: 'complexrecipes', body: {
          query: {
              match_all: {
              }
          }
      }
    else
      search = $elastic.search index: 'homestaurant', type: 'complexrecipes', body: {
          query: {
              query_string: {
                  query: params[:query][:text]
              }
          }
      }
    end

    page = Integer((params[:commit] ? params[:commit] : '1'))
    rangemin = page * 9 - 9
    rangemax = page * 9 - 1

    all_recipes = []
    (rangemin..rangemax).each do |index|
      all_recipes.push search['hits']['hits'][index]['_source'] unless search['hits']['hits'][index].nil?
    end

    @itemlist = (all_recipes)[rangemin .. rangemax]
    @thumbtype = :recipe
    @query = params[:query][:text]
    @pagecount = all_recipes.length / 9 + 1
  end

  # def redis_cache
  #   unless ($redis.get 'omniselect_valid') == 'true'
  #     $redis.multi do
  #       $redis.set 'omniselect_valid', true, {ex: 300}
  #       omniselect = execute_sql 'SELECT r.id, r.name, r.guide, avg(rr.quality) as avgquality, avg(rr.difficulty) as avgdifficulty, avg(rr.time) as avgtime, json_agg(i.name) as namearray, json_agg(c.amount) as amountarray, json_agg(c.details) as detailsarray FROM recipes r LEFT JOIN components c ON c.recipe_id = r.id LEFT JOIN ingredients i ON i.id = c.ingredient_id LEFT JOIN recipe_ratings rr ON r.id = rr.recipe_id
  #                 GROUP BY r.id, r.name, r.guide'
  #       omniselect.each do |row|
  #         $redis.zadd 'omniselect', row[:avgquality], row.to_json
  #         $redis.zadd 'idToQuality', row[:id], row[:avgquality]
  #       end
  #     end
  #   end
  # end

  def show
    select = Recipe.find_by_sql "SELECT r.name as rname, r.*, i.name as iname,r.user_id, c.details, c.amount FROM recipes r
                                  LEFT JOIN components c ON c.recipe_id = r.id LEFT JOIN ingredients i ON i.id = c.ingredient_id WHERE r.id = #{params[:id]}"

    recipe_rating = (Recipe.find_by_sql "SELECT avg(quality) as quality,avg(difficulty) as difficulty,avg(time) as time FROM recipes r JOIN recipe_ratings rr ON rr.recipe_id = r.id WHERE r.id = #{params[:id]}")[0]
    @quality = recipe_rating[:quality].nil? ? 'not yet rated' : recipe_rating[:quality]
    @difficulty = recipe_rating[:difficulty].nil? ? 'not yet rated' : recipe_rating[:difficulty]
    @time = recipe_rating[:time].nil? ? 'not yet rated' : recipe_rating[:time]
    @recipe = select[0]
    @ingredientlist = []
    select.each do |component|
      @ingredientlist.push({name: component[:iname], details: component[:details], amount: component[:amount]})
    end
  end

  def recipes_to_try
    @pagecount = 0
    if current_user.nil?
      redirect_to '/login'
      return
    end

    all_recipes = Recipe.find_by_sql "SELECT r.name,r.id FROM recipes r JOIN my_recipes_memberships mrm ON mrm.recipe_id = r.id WHERE mrm.user_id = #{current_user[:id]}"
    page = Integer((params[:commit] ? params[:commit] : '1'))
    rangemin = page * 9 - 9
    rangemax = page * 9 - 1
    @itemlist = all_recipes[rangemin .. rangemax]
    @thumbtype = :recipe
    @pagecount = all_recipes.to_a.length / 9 + 1
  end

  def new
    if current_user.nil?
      redirect_to '/login'
      return
    end

    all_ingredients = Ingredient.find_by_sql 'SELECT name,id FROM ingredients'

    @ingredientlist = {:'Choose ingredient type' => 0}
    all_ingredients.each do |i|
      @ingredientlist[i[:name]] = i[:id]
      puts i[:id]
    end

  end

  def create
    if current_user.nil?
      redirect_to '/login'
      return
    end

    recipe_params = params.require(:recipe).permit(:name, :guide)
    @recipe = Recipe.new(recipe_params)

    if @recipe.invalid?
      render 'new'
      return
    end

    recipe = nil

    ActiveRecord::Base.connection.transaction do
      execute_sql "INSERT INTO recipes (name,guide,created_at,updated_at,user_id)
                 values ('#{params[:recipe][:name]}','#{params[:recipe][:guide]}',timestamptz '#{Time.now}',timestamptz '#{Time.now}','#{current_user[:id]}')"

      recipe = Recipe.find_by_sql 'SELECT id FROM recipes ORDER BY id desc LIMIT 1'

      ingredients = params[:recipe].clone
      ingredients.delete(:name)
      ingredients.delete(:guide)
      ingredients.delete(:commit)

      ingredients.each_slice(3) do |slice|
        execute_sql "INSERT INTO components (ingredient_id,recipe_id,details,amount,created_at,updated_at)
                   values ('#{slice[0].last}',#{recipe[0][:id]},'#{slice[1].last}','#{slice[2].last}',timestamptz '#{Time.now}',timestamptz '#{Time.now}')"
      end
    end
    redirect_to '/recipes/my_recipes'

    to_elastic = (ActiveRecord::Base.connection.execute "SELECT r.id, r.name, r.guide, avg(rr.quality) as avgquality,
                                                   avg(rr.difficulty) as avgdifficulty, avg(rr.time) as avgtime,
                                                   json_agg(i.name) as namearray, json_agg(c.amount) as amountarray,
                                                   json_agg(c.details) as detailsarray FROM recipes r
                                                   LEFT JOIN components c ON c.recipe_id = r.id
                                                   LEFT JOIN ingredients i ON i.id = c.ingredient_id
                                                   LEFT JOIN recipe_ratings rr ON r.id = rr.recipe_id
                                                   GROUP BY r.id, r.name, r.guide HAVING r.id = #{recipe[0][:id]}")[0]

    $elastic.index index: 'homestaurant', type: 'complexrecipes', id: to_elastic['id'], body: to_elastic
  end

  def suggest
    itemlist = (execute_sql "SELECT ss.id, ss.name, CASE WHEN ss.avg IS NULL THEN 0 ELSE ss.avg END
                                        FROM (SELECT i.id, i.name, avg(ir.rating) FROM ingredients i
                                        LEFT JOIN ingredient_ratings ir ON ir.ingredient_id = i.id
                                        WHERE ir.user_id = #{current_user.id} OR ir.user_id IS NULL
                                        GROUP BY i.name, i.id) ss ORDER BY avg DESC").to_a

    @synchronizer = (Time.now).to_i
    @itemlist = itemlist[0..3]
    @thumbtype = :ingredient
    @squaresize = 2

    itemlist[4..-1].each do |item|
      $redis.rpush "recipesuggest:#{current_user.id}:#{@synchronizer}", item
    end
    $redis.expire "recipesuggest:#{current_user.id}:#{@synchronizer}", 600

  end

  def rate
    select = Recipe.find_by_sql "SELECT * FROM recipes
                                  WHERE id = #{params[:id]}"
    @recipe = select[0]
  end

  def createrating
    execute_sql "INSERT INTO recipe_ratings (recipe_id,quality,difficulty,time,created_at,updated_at)
                 values (#{params[:id]},#{params[:rating][:quality]},#{params[:rating][:difficulty]},#{params[:rating][:time]},timestamptz '#{Time.now}',timestamptz '#{Time.now}')"
    redirect_to '/recipes/recipes_to_try'
  end

  def destroy
    recipe = (Recipe.find_by_sql "SELECT * FROM recipes WHERE id=#{params[:id]}")[0]
    unless recipe[:user_id] == current_user[:id]
      redirect_to '/home'
      return
    end

    ActiveRecord::Base.connection.transaction do
      execute_sql "DELETE FROM comments WHERE recipe_id = #{params[:id]}"
      execute_sql "DELETE FROM components WHERE recipe_id = #{params[:id]}"
      execute_sql "DELETE FROM recipe_ratings WHERE recipe_id = #{params[:id]}"
      execute_sql "DELETE FROM my_recipes_memberships WHERE recipe_id = #{params[:id]}"
      execute_sql "DELETE FROM favorites_memberships WHERE recipe_id = #{params[:id]}"
      execute_sql "DELETE FROM recipes WHERE id = #{params[:id]}"
    end

    redirect_to '/recipes/my_recipes'

    ApplicationController.elastic_reindex

  end

  def getnext

    unless params[:unlike].nil?
      execute_sql "INSERT INTO ingredient_ratings (user_id,ingredient_id, rating, created_at, updated_at)
                   values (#{current_user.id},#{params[:unlike]},-5,timestamptz '#{Time.now}',timestamptz '#{Time.now}')"
    end

    puts params[:synchronizer]
    redis_incoming = $redis.lpop "recipesuggest:#{current_user.id}:#{params['synchronizer']}"
    hash = nil
    hash = eval redis_incoming unless redis_incoming.nil?
    @recipe = hash
    if @recipe == nil
      render nothing: true
      return
    end
    render layout: false
  end

end