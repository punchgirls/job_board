require "cuba/test"
require_relative "../../app"

prepare do
  Ohm.flush

  Company.create({ name: "Punchgirls",
    email: "punchgirls@mail.com",
    url: "http://www.punchgirls.com",
    password: "12345678" })

  time = Time.new.to_i

  Post.create({ date: time,
    expiration_date: time + (30 * 24 * 60 * 60),
    tags: "Java, C++, Ruby",
    location: "New York, NY",
    remote: "true",
    title: "Java developer",
    description: "Lorem ipsum dolor sit amet,
    consectetur adipiscing elit. Nulla a enim enim.
    Vestibulum nec magna neque. Suspendisse euismod metus dapibus,
    congue sem cursus, elementum urna. Integer lorem mauris,
    ornare pharetra tincidunt nec, mattis commodo diam.",
    company_id: "1" })

    Post.create({ date: time,
      expiration_date: time + (30 * 24 * 60 * 60),
      tags: "Ruby, Redis",
      location: "New York, NY",
      remote: "false",
      title: "Redis developer",
      description: "Lorem ipsum dolor sit amet,
    consectetur adipiscing elit. Nulla a enim enim.
    Vestibulum nec magna neque. Suspendisse euismod metus dapibus,
    congue sem cursus, elementum urna. Integer lorem mauris,
    ornare pharetra tincidunt nec, mattis commodo diam.",
      company_id: "1" })

    Post.create({ date: time,
      expiration_date: time + (30 * 24 * 60 * 60),
      tags: "Ruby",
      location: "Drammen, Norway",
      remote: "false",
      title: "Ruby developer",
      description: "Lorem ipsum dolor sit amet,
    consectetur adipiscing elit. Nulla a enim enim.
    Vestibulum nec magna neque. Suspendisse euismod metus dapibus,
    congue sem cursus, elementum urna. Integer lorem mauris,
    ornare pharetra tincidunt nec, mattis commodo diam.",
      company_id: "1" })

    Post.create({ date: time,
      expiration_date: time + (30 * 24 * 60 * 60),
      tags: "Ruby, Cuba",
      location: "Buenos Aires, Argentina",
      remote: "true",
      title: "Ruby developer",
      description: "Lorem ipsum dolor sit amet,
    consectetur adipiscing elit. Nulla a enim enim.
    Vestibulum nec magna neque. Suspendisse euismod metus dapibus,
    congue sem cursus, elementum urna. Integer lorem mauris,
    ornare pharetra tincidunt nec, mattis commodo diam.",
      company_id: "1" })
end

scope do
  test "should display Ruby developer post" do
    post "/login", { email: "punchgirls@mail.com",
          password: "12345678" }

    follow_redirect!

    get "/search", { post: { location: "",
          tags: "Redis" }}

    assert last_response.body["Redis developer"]
  end

  test "should display no posts" do
    post "/login", { email: "punchgirls@mail.com",
          password: "12345678" }

    get "/search", { post: { location: "",
          tags: "CSS" }}

    assert last_response.body["No posts matched your search. Try again!"]
  end
end
