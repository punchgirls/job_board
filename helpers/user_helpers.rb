module UserHelpers
  def current_user
    authenticated(Developer) || authenticated(Company)
  end

  def mote_vars(content)
    super.merge(current_user: current_user)
  end

  def notfound(msg)
    res.status = 404
    res.write(msg)
    halt(res.finish)
  end

  def forbidden(msg)
    res.status = 403
    res.write(msg)
    halt(res.finish)
  end

  def h(text)
    text.to_s.encode(xml: :text)
  end

  def not_found!
    res.status = 404
    render("404", title: "Not found")
    halt res.finish
  end
end
