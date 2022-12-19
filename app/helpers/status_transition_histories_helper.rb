# frozen_string_literal: true

module StatusTransitionHistoriesHelper
  def get_reason(history)
    history.reason.html_safe
  end
end
