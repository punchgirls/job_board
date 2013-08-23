class Post < Ohm::Model
  include Shield::Model
  include Ohm::Callbacks

  attribute :date
  attribute :expiration_date
  attribute :title
  attribute :description

  def posted
    return Time.at(date.to_i).strftime("%d %B %Y")
  end

  def expires
    return (expiration_date.to_f - Time.new.to_i) / (60 * 60)
  end

  def expired?
    return (expiration_date.to_i - Time.now.to_i) <= 0
  end

  def developers
    developers = []

    applications.each do |application|
      if !developers.include?(application.developer)
        developers << application.developer
      end
    end

    favorited_by.each do |developer|
      if !developers.include?(developer)
        developers << developer
      end
    end

    return developers
  end

  def before_delete
    developers.each do |developer|
      Malone.deliver(to: developer.email,
        subject: "Auto-notice: '" + self.title + "' post has been removed",
        html: "<p>" + "Dear " + developer.name + "</p>" +
        "<p>We are sorry to inform you that the post '" +
        self.title + "' has been removed.</p>" +
        "<p>Remember that there are a lot more jobs waiting at <a href='http://os-job-board.herokuapp.com'>Job Board</a>!</p>")
    end

    applications.each(&:delete)
    favorites.each(&:delete)

    favorited_by.each do |developer|
      developer.favorites.delete(self)
    end

    super
  end

  reference :company, :Company

  collection :applications, :Application
  set :favorites, :Application
  set :favorited_by, :Developer
end
