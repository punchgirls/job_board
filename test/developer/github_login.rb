require "cuba/test"
require_relative "../../app"

prepare do
  Ohm.flush

  Developer.create({ username: "punchgirls",
          github_id: 123456,
          name: "Punchies",
          email: "punchgirls@mail.com" })
end

# Redefine fetch_user method to fake GitHub response

module GitHub
  def self.fetch_user(access_token)
    return {:github_id=>"123456", :username=>"punchgirls",
      :name=>"Punchies", :email=>"punchgirls@gmail.com"}
  end
end

scope do
  test "should redirect to GitHub login" do
    get "/github_oauth"

    assert_equal 302, last_response.status
  end

  test "should inform User of successful signup" do
    post "/github_login/117263273765215762"

    follow_redirect!

    assert last_response.body["You have successfully logged in."]
  end
end
