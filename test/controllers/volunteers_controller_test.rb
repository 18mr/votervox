require 'test_helper'

class VolunteersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get approve" do
    get :approve
    assert_response :success
  end

  test "should get ban" do
    get :ban
    assert_response :success
  end

  test "should get make_admin" do
    get :make_admin
    assert_response :success
  end

end
