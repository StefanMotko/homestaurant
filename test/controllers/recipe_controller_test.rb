require 'test_helper'

class RecipeControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end
  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should get favorites' do

  end
end
