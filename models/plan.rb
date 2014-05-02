class Plan
  POSTS = {
    "free"  => 5,
    "small"  => 1,
    "medium" => 5,
    "large"  => 10,
    "punchgirls"  => 1000
  }

  PRICING = {
    "free"  => 0,
    "small"  => 9,
    "medium" => 15,
    "large"  => 25,
    "punchgirls"  => 0
  }

  attr :id

  def self.[](id)
    new(id)
  end

  def initialize(id)
    @id = id
  end

  def posts
    POSTS[@id]
  end

  def price
    PRICING[@id]
  end

  def name
    @id
  end
end
