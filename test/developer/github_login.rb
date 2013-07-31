require "cuba/test"
require_relative "../../app"

prepare do
  Ohm.flush
end

scope do
  test "should redirect to GitHub login" do
    get "/github_oauth"

    assert_equal 302, last_response.status
  end

  test "should receive temporary code from GitHub" do
    post "/github_oauth", { code: "000000" }

    assert_equal 302, last_response.status
  end
end
