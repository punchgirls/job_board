module GitHub
  def self.fetch_access_token(code)
    response = Requests.request("POST", GITHUB_OAUTH_ACCESS_TOKEN,
      data: { client_id: GITHUB_CLIENT_ID,
              client_secret: GITHUB_CLIENT_SECRET,
              code: code },
      headers: { "Accept" => "application/json" })

    return JSON.parse(response.body)["access_token"]
  end

  def self.login_url(access_token)
    return "/github_login/#{ access_token }"
  end

  def self.fetch_user(access_token)
    return JSON.parse((Requests.request("GET", GITHUB_FETCH_USER,
          params: { access_token: access_token })).body)
  end

  def self.oauth_authorize
    return "#{ GITHUB_OAUTH_AUTHORIZE }?client_id=#{ GITHUB_CLIENT_ID }"
  end
end
