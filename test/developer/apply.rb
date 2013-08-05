require "cuba/test"
require_relative "../../app"

prepare do
  Ohm.flush

  Company.create({ name: "Punchgirls",
          email: "punchgirls@mail.com",
          url: "http://www.punchgirls.com",
          password: "1234" })

  Post.create({ title: "Ruby developer",
          description: "Ruby ninja needed!",
          company_id: "1" })

  Developer.create({ username: "johndoe",
          github_id: "123456",
          name: "John Doe",
          email: "johndoe@mail.com" })
end

# Redefine fetch_user method to fake GitHub response

module GitHub
  def self.fetch_user(access_token)
    return { :github_id=>"123456", :username=>"johndoe",
      :name=>"John Doe", :email=>"johndoe@gmail.com" }
  end
end

scope do
  test "should inform User of successful application" do
    post "/github_login/117263273765215762"

    post "/apply/1", { date: Time.new,
        developer_id: "1",
        post_id: "1" }

    follow_redirect!

    assert last_response.body["You have successfully applied for a job!"]
  end
end
