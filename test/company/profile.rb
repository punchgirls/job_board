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
end

scope do
  test "should display company profile" do
    post "/login", { company: { email: "punchgirls@mail.com",
      password: "123456" }}

    get "/profile"

    assert last_response.body["punchgirls@mail.com"]
  end
end
