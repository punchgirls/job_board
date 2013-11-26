require "cuba/test"
require_relative "../../app"

# Redefine fetch_user method to fake GitHub response

module GitHub
 def self.fetch_user(access_token)
   return { "id"=>"123456", :username=>"johndoe",
     :name=>"John Doe", :email=>"johndoe@gmail.com" }
 end
end

prepare do
  Ohm.flush

  time = Time.new.to_i

  Company.create({ name: "Punchgirls",
          email: "punchgirls@mail.com",
          url: "http://www.punchgirls.com",
          password: "12345678" })

  Post.create({ date: time,
        expiration_date: time + (30 * 24 * 60 * 60),
        tags: "Java, C++",
        location: "New York, NY",
        title: "Java developer",
        description: "Lorem ipsum dolor sit amet,
        consectetur adipiscing elit. Nulla a enim enim.
        Vestibulum nec magna neque. Suspendisse euismod metus dapibus,
        congue sem cursus, elementum urna. Integer lorem mauris,
        ornare pharetra tincidunt nec, mattis commodo diam.
        Ut id cursus felis, nec fringilla libero. Vivamus ullamcorper,
        felis non congue elementum, risus mauris vulputate leo,
        vel consequat urna lacus at tortor. Nullam auctor lorem diam,
        a fringilla felis adipiscing nec. Aliquam sed arcu facilisis,
        porta est sit amet, dapibus quam. Lorem ipsum dolor sit amet,
        consectetur adipiscing elit. Curabitur posuere.",
        company_id: "1" })

  Developer.create({ username: "johndoe",
          github_id: "123456",
          name: "John Doe",
          email: "johndoe@mail.com" })
end

scope do
  test "should inform User of successful application" do
    post "/github_login/117263273765215762"

    post "/apply/1", { date: Time.new.to_i,
        developer_id: "1",
        post_id: "1" }

    follow_redirect!

    assert last_response.body["You have successfully applied for a job!"]
  end

  test "should display developer applications" do
    post "/github_login/117263273765215762"

    post "/apply/1"

    get "/applications"

    assert last_response.body["Java developer"]
  end

  test "should remove application" do
    post "/github_login/117263273765215762"

    post "/apply/1"

    post "/remove/1"

    get "/applications"

    assert last_response.body["Application successfully removed!"]

    assert !last_response.body["Java developer"]
  end
end
