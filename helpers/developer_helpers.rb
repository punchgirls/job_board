module DeveloperHelpers
  def current_developer
    authenticated(Developer)
  end

  def mote_vars(content)
    super.merge(current_developer: current_developer)
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
end
