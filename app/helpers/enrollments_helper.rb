# frozen_string_literal: true

module EnrollmentsHelper
  def find_trainee(id)
    User.find(id)
  end
end
