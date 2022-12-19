# frozen_string_literal: true

class PreferencesController < ApplicationController
  def index
    @active = 'ic-gear'
    @heading = 'Settings'
    @preference = current_user.preference
    @calendars = Calendar.get_calendar_list(current_user).items.map(&:id)
  end

  def update
    @preference = Preference.find(params[:id])
    @preference.update(update_params)
  end

  private

    def update_params
      params.require(:preference).permit(:dark_mode, :calendar_name)
    end
end
