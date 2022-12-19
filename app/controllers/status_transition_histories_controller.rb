# frozen_string_literal: true

class StatusTransitionHistoriesController < ApplicationController
  def index
    @status_transition_history = StatusTransitionHistory.where(historic_id: index_params[:historic_id],
                                                               historic_type: index_params[:historic_type])
                                                        .order(created_at: :desc)
  end

  private

    def index_params
      params.permit(:historic_id, :historic_type)
    end
end
