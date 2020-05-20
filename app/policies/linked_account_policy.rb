class LinkedAccountPolicy < ApplicationPolicy
  def create?
    user.is_member?
  end

  def update?
    record.user_id == user.id
  end
end
