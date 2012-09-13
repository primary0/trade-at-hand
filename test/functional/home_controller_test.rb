require 'test_helper'

class HomeControllerTest < ActionController::TestCase

  test "get index" do
    get :index
    assert :success
  end
end
