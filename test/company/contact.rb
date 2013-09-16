require "cuba/test"
require_relative "../../app"

prepare do
  Ohm.flush

  Company.create({ name: "Punchgirls",
          email: "punchgirls@mail.com",
          url: "http://www.punchgirls.com",
          password: "12345678" })

  Post.create({ title: "Ruby developer",
          description: "Ruby ninja needed!",
          tags: "Ruby, Cuba",
          location: "New York, NY",
          company_id: "1" })

  Developer.create({ username: "johndoe",
          github_id: "123456",
          name: "John Doe",
          email: "johndoe@mail.com" })

  Application.create({ date: Time.new,
        developer_id: "1",
        post_id: "1" })
end

scope do
  test "should inform Company of mail sent successfully" do
    post "/login", { email: "punchgirls@mail.com",
          password: "12345678" }

    post "/application/contact/1", { message: { subject: "Test",
          body: "This is a test message" }}

    follow_redirect!

    assert last_response.body["You just sent an e-mail to the applicant!"]
  end

end
