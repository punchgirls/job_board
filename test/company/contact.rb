require "cuba/test"
require_relative "../../app"

prepare do
  Ohm.flush

  Company.create({ name: "Punchgirls",
    email: "punchgirls@mail.com",
    url: "http://www.punchgirls.com",
    password: "123456",
    credits: "8",
    customer_id: "cus_2wnQ01IoAywTZz" })

  time = Time.new.to_i

  Post.create({ date: 1270833200,
    expiration_date: 1070833200,
    tags: "Ruby, Python",
    location: "New York, NY, United States",
    remote: "true",
    title: "Ruby developer",
    description: "Your tasks will be: Develop and maintain our services API, interact with Redis and ElasticSearch and design and implement a monitoring framework. Skills and experience: Knowledge of Ruby, Python or Go programming languages; Redis commands; and ElasticSearch query API. Experience in any of these is a plus though we also have a test project for you to prove yourself! Benefits: Working remotely, no phone calls meetings unless necessary, annual team meeting somewhere around the world :)",
    company_id: "1" })

  Post.create({ date: time,
    expiration_date: time + (30 * 24 * 60 * 60),
    tags: "Ruby",
    location: "New York, NY, United States",
    remote: "false",
    title: "Java developer",
    description: "Your tasks will be: Develop and maintain our services API, interact with Redis and ElasticSearch and design and implement a monitoring framework. Skills and experience: Knowledge of Ruby, Python or Go programming languages; Redis commands; and ElasticSearch query API. Experience in any of these is a plus though we also have a test project for you to prove yourself! Benefits: Working remotely, no phone calls meetings unless necessary, annual team meeting somewhere around the world :)",
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
    post "/login", { company: { email: "punchgirls@mail.com",
      password: "123456" }}

    post "/application/contact/1", { message: { subject: "Test",
          body: "This is a test message" }}

    follow_redirect!

    assert last_response.body["You just sent an e-mail to the applicant!"]
  end
end
