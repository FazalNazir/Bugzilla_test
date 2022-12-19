# frozen_string_literal: true

class SyncsController < ApplicationController
  include CommonConcern
  before_action :set_selected_menus, :user_search_query
  before_action :set_sync, only: :show

  def index
    @syncs = if index_params[:list]
               @query.result(distinct: true).includes(:supervisor, :event).on_date(params[:date] || DateTime.now)
             else
               @query.result(distinct: true).includes(:event)
             end.paginate(page: params[:page])
  end

  def show; end

  def new
    @sync = Sync.new
    @sync.build_event
    Calendar.use_client(current_user) do |client, _logged_user|
      @colors = client.get_color
    end
  end

  def create
    @sync = Sync.new(create_params)
    @sync.assign_trainees(params[:trainees])
    @sync.create_calendar_event(current_user) && @sync.save
  end

  private

    def set_selected_menus
      @active = 'ic-calendar'
      @sub_active = 'Manage Sync'
      @heading = 'Manage Training'
    end

    def index_params
      params[:list] = (params[:list] == 'true')
      params.permit(:list)
    end

    def set_sync
      @sync = Sync.find(id)
    end

    def user_search_query
      @user_query = User.ransack(params[:query])
    end

    def create_params
      params.require(:sync).permit(:supervisor_id, event_attributes: %i[title start_date end_date recur_by
                                                                        recur_every location description
                                                                        color_id])
    end
end
