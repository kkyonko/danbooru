class LinkedAccountsController < ApplicationController
  respond_to :html, :js, :xml, :json

  def new
    @linked_account = authorize LinkedAccount.new(user: CurrentUser.user, type: "LinkedAccount::#{params[:site]}"), policy_class: LinkedAccountPolicy
    respond_with(@linked_account)
  end

  def index
    if params[:user_id].present?
      @user = User.find(params[:user_id])
      @linked_accounts = authorize LinkedAccount.visible(@user).paginated_search(params, count_pages: true), policy_class: LinkedAccountPolicy
    else
      @linked_accounts = authorize LinkedAccount.visible(CurrentUser.user).paginated_search(params, count_pages: true), policy_class: LinkedAccountPolicy
    end

    respond_with(@linked_accounts)
  end

  def destroy
    @linked_account = authorize LinkedAccount.find(params[:id]), policy_class: LinkedAccountPolicy
    @linked_account.destroy
    respond_with(@linked_account)
  end

  def callback
    if params[:error]
      @linked_account = nil
    else
      @linked_account = LinkedAccount.link_account!(user: CurrentUser.user, code: params[:code], state: params[:state])
    end

    respond_with(@linked_account)
  end
end
