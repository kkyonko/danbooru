class LinkedAccount::DeviantArt < LinkedAccount
  def site_url
    "https://www.deviantart.com"
  end

  def user_name
    account_data["username"]
  end

  def profile_url
    "https://www.deviantart.com/#{user_name}"
  end

  def fetch_account_data(http)
    response = http.headers(Authorization: "Bearer #{api_key["access_token"]}").get("https://www.deviantart.com/api/v1/oauth2/user/whoami?expand=user.details,user.geo,user.profile,user.stats")
    self.account_data = response.parse
    self.account_id = account_data["userid"]
  end
end
