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

  Post.create({ date: time,
    expiration_date: time + (30 * 24 * 60 * 60),
    tags: "Ruby",
    location: "New York, NY",
    title: "Ruby developer",
    description: "Lorem ipsum dolor sit amet,
    consectetur adipiscing elit. Morbi condimentum,
    odio at fringilla commodo, tellus nisi bibendum
    ",
    company_id: "1" })
end

scope do
  test "should inform of missing tags" do
    post "/login", { company: { email: "punchgirls@mail.com",
      password: "123456" }}

    post "/post/edit/1", { post: { tags: "",
      location: "New York, NY",
      title: "Ruby master",
      description: "Ruby oracle needed!" }}

    assert last_response.body["At least one skill is required"]
  end

  test "should inform of missing title" do
    post "/login", { company: { email: "punchgirls@mail.com",
      password: "123456" }}

    post "/post/edit/1", { post: { tags: "Ruby, Cuba",
          location: "New York, NY",
          title: "",
          description: "Ruby oracle needed!" }}

    assert last_response.body["Title is required"]
  end

  test "should inform of title out of range" do
    post "/login", { company: { email: "punchgirls@mail.com",
      password: "123456" }}

    post "/post/edit/1", { post: { tags: "Ruby, Cuba",
          location: "New York, NY",
          title: "Ruby oracle needed! Ruby oracle needed!
            Ruby oracle needed! Ruby oracle needed!
            Ruby oracle needed! Ruby oracle needed!
            Ruby oracle needed! Ruby oracle needed!",
          description: "Ruby oracle needed!" }}

    assert last_response.body["Title should not exceed 80 characters"]
  end

  test "should inform of missing description" do
    post "/login", { company: { email: "punchgirls@mail.com",
      password: "123456" }}

    post "/post/edit/1", { post: { tags: "Ruby, Cuba",
          location: "New York, NY",
          title: "Ruby master",
          description: "" }}

    assert last_response.body["Description is required"]
  end

  test "should inform of description out of range" do
    post "/login", { company: { email: "punchgirls@mail.com",
      password: "123456" }}

    post "/post/edit/1", { post: { tags: "Ruby, Cuba",
          location: "New York, NY",
          title: "Ruby master",
          description: "Lorem ipsum dolor sit amet,
            consectetur adipiscing elit. Morbi condimentum,
            odio at fringilla commodo, tellus nisi bibendum
            tellus, sit amet posuere tortor nunc vitae quam.
            Pellentesque lacus quam, hendrerit vel orci eu,
            varius sodales urna. Suspendisse faucibus
            vehicula iaculis. Vivamus vulputate est tellus,
            ac semper orci ullamcorper ut. Aliquam erat volutpat.
            Cras sollicitudin, velit vel sollicitudin molestie,
            est purus suscipit felis, sit amet sagittis nisl
            lorem quis nisl. Aliquam posuere sem et ligula
            pulvinar auctor. Sed vel tortor nunc. In hac
            habitasse platea. Lorem ipsum dolor sit amet,
            consectetur adipiscing elit. Morbi condimentum,
            odio at fringilla commodo, tellus nisi bibendum
            tellus, sit amet posuere tortor nunc vitae quam.
            Pellentesque lacus quam, hendrerit vel orci eu,
            varius sodales urna. Suspendisse faucibus
            vehicula iaculis. Vivamus vulputate est tellus,
            ac semper orci ullamcorper ut. Aliquam erat volutpat.
            Cras sollicitudin, velit vel sollicitudin molestie,
            est purus suscipit felis, sit amet sagittis nisl
            lorem quis nisl. Aliquam posuere sem et ligula
            pulvinar auctor. Sed vel tortor nunc. In hac
            habitasse platea." }}

    assert last_response.body["Description should not exceed 600 characters"]
  end

  test "should inform of successful update" do
    post "/login", { company: { email: "punchgirls@mail.com",
      password: "123456" }}

    post "/post/edit/1", { post: { tags: "Ruby, Cuba",
          location: "New York, NY",
          title: "Ruby master",
          description: "Ruby oracle needed!" }}

    follow_redirect!

    assert last_response.body["Post successfully edited!"]

    assert last_response.body["Ruby master"]
  end
end
