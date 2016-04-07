require 'test_helper'

class RecipesControllerTest < ActionController::TestCase
  test "should get my_recipes" do
    get :my_recipes
    assert_response :success
  end

  test "should get favorites" do
    get :favorites
    assert_response :success
  end

  test "should get browse" do
    get :browse
    assert_response :success
  end

end
