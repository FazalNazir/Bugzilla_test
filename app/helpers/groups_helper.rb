# frozen_string_literal: true

module GroupsHelper
  def get_user_count_from_group(group)
    group.users.count
  end
end
