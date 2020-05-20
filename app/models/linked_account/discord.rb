class LinkedAccount::Discord < LinkedAccount
  def site_url
    "https://discord.com"
  end

  def user_name
    "#{account_data["username"]}##{account_data["discriminator"]}"
  end

  def fetch_account_data(http)
    response = http.headers(Authorization: "Bearer #{api_key["access_token"]}").get("https://discord.com/api/users/@me")
    self.account_data = response.parse
    self.account_id = account_data["id"]
  end
end
