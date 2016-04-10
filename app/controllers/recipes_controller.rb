class RecipesController < ApplicationController

  def my_recipes
    if current_user.nil?
      redirect_to '/login'
      return
    end

    all_recipes = Recipe.find_by_sql "SELECT name FROM recipes WHERE user_id = #{current_user[:id]}"
    page = Integer((params[:page] ? params[:page] : '1'))
    rangemin = page * 9 - 9
    rangemax = page * 9 - 1
    @itemlist = all_recipes[rangemin .. rangemax]
    @thumbtype = :recipe
  end

  def favorites
  end

  def browse
  end

  def recipes_to_try
    if current_user.nil?
      redirect_to '/login'
      return
    end

    all_recipes = Recipe.find_by_sql "SELECT r.name FROM recipes r JOIN my_recipes_memberships mrm ON mrm.recipe_id = r.id WHERE mrm.user_id = #{current_user[:id]}"
    page = Integer((params[:page] ? params[:page] : '1'))
    rangemin = page * 9 - 9
    rangemax = page * 9 - 1
    @itemlist = all_recipes[rangemin .. rangemax]
    @thumbtype = :recipe
  end

  def new
    if current_user.nil?
      redirect_to '/login'
      return
    end

    @recipe = Recipe.new
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

    execute_sql "INSERT INTO recipes (name,guide,created_at,updated_at,user_id)
                 values ('#{params[:recipe][:name]}','#{params[:recipe][:guide]}',timestamptz '#{Time.now}',timestamptz '#{Time.now}','#{current_user[:id]}')"
    render 'my_recipes'
  end

end
