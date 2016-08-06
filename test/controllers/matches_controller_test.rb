require 'test_helper'

class MatchesControllerTest < ActionController::TestCase
  test "should get voter_match" do
    get :voter_match
    assert_response :success
  end

  test "should get accept" do
    get :accept
    assert_response :success
  end

  test "should get reject" do
    get :reject
    assert_response :success
  end

  test "should get request_time" do
    get :request_time
    assert_response :success
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get create" do
    get :create
    assert_response :success
  end

  test "should get decline" do
    get :decline
    assert_response :success
  end

  test "should get show" do
    get :show
    assert_response :success
  end

end
