require 'test_helper'

class MetricsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end
