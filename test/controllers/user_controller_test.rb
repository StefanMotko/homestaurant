require 'test_helper'

class UserControllerTest < ActionController::TestCase
  test "should get new,create" do
    get :new,create
    assert_response :success
  end

end
