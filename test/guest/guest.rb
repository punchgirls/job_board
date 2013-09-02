require "cuba/test"
require_relative "../../app"

prepare do
  Ohm.flush
end

scope do
  test "should display homepage" do
    get "/"

    assert_equal 200, last_response.status
  end

  test "should display posts" do
    get "/search"

    assert_equal 200, last_response.status
  end
end
