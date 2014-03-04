class Application < Ohm::Model
  include Ohm::Callbacks

  attribute :date
  attribute :message
  attribute :note
  attribute :status

  index :status
  index :active?

  def active?
    return status == "active"
  end

  def applied
    return Time.at(date.to_i).strftime("%e %b.")
  end

  def before_delete
    post.favorites.delete(self)

    super
  end

  reference :post, :Post
  reference :developer, :Developer
end
