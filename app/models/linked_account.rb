class LinkedAccount < ApplicationRecord
  SITES = ["DeviantArt", "Discord"]

  belongs_to :user

  scope :is_public, -> { where(is_public: true) }
  scope :is_private, -> { where(is_public: false) }

  def self.visible(user)
    if user.is_admin?
      all
    else
      where(user: user).or(is_public)
    end
  end

  def self.search(params = {})
    q = super
    q = q.search_attributes(params, :user, :type, :account_id, :is_public, :account_data_updated_at, :api_key_updated_at)
    q = q.apply_default_order(params)
    q
  end

  def self.link_account!(user:, code:, state:)
    oauth2_client = Oauth2Client.from_state!(state, user)
    access_token = oauth2_client.access_token(code)

    linked_account = LinkedAccount.new(user: user, type: "LinkedAccount::#{oauth2_client.site}", api_key: access_token)
    linked_account.fetch_account_data(oauth2_client.http)
    linked_account.tap(&:save!)
  end

  def self.api_attributes
    super - [:api_key, :account_data, :api_key_updated_at, :account_data_updated_at]
  end

  def site_name
    self.class.name.demodulize
  end

  def user_name
    nil
  end

  def profile_url
    nil
  end

  def site_url
    nil
  end

  def fetch_account_data
    nil
  end

  def authorization_url(redirect_uri:)
    Oauth2Client.new(site_name, redirect_uri: redirect_uri).authorization_url(user: user)
  end

  def api_key=(api_key)
    super(api_key)
    self.api_key_updated_at = Time.zone.now if api_key_changed?
  end

  def account_data=(account_data)
    super(account_data)
    self.account_data_updated_at = Time.zone.now if account_data_changed?
  end
end
