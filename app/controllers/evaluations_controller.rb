# frozen_string_literal: true

class EvaluationsController < ApplicationController
  include Wicked::Wizard

  before_action :set_steps
  before_action :setup_wizard
  before_action :search_query
  before_action :set_layout_option
  before_action :date_convert, only: :update, if: proc { step == :assign_event_date }
  before_action :set_evaluation, only: %i[show update edit]

  def index
    @evaluations = @query.result(distinct: true).paginate(page: params[:page])
    if params.key?(:task_id)
      @task = Task.find(index_params[:task_id])
      @evaluations = @task.evaluations.where(status: APPROVED).paginate(page: params[:page])
    end
    @evaluations = if current_user.has_role?(:super_user)
                     Evaluation.includes(:enrollment, :evaluator).paginate(page: params[:page])
                   else
                     policy_scope(Evaluation).includes(:enrollment, :event).paginate(page: params[:page])
                   end
    @evaluations = @evaluations.ransack(params[:query]).result(distinct: true).paginate(page: params[:page])
  end

  def show
    @evaluator = User.where(id: show_params[:evaluator_id]).first
    render_wizard
  end

  def edit; end

  def update
    case step
      when :assign_evaluator
        add_flash(@evaluation.update(evaluator_id: update_params[:evaluation]&.[](:evaluator_id)),
                  'Evaluator Assigned.', 'Please assign Evaluator')
      when :assign_event_date
        @evaluation.build_event(update_params[:event]) unless @evaluation.event
        if !@evaluation.event.id || @evaluation.event.update(update_params[:event])
          @evaluation.create_calendar_event(current_user)
        end
        accept_evaluation
      when :reject_request
        reject_evaluation
      when :evaluator_reject_request
        evaluator_rejection
      when :complete_evaluation
        add_flash(@evaluation.complete, 'Evaluation completed!', "Evaluation cant be
                  completed from #{@evaluation.status} status.")
    end
    render_wizard(@evaluation, {},
                  { evaluation_id: @evaluation.id, flow: update_params[:flow] || :accept,
                    evaluator_id: update_params[:evaluation]&.[](:evaluator_id), date: update_params[:date] })
  end

  private

    def id
      params[:evaluation_id] ? params.require(:evaluation_id) : params.require(:id)
    end

    def set_evaluation
      @evaluation = Evaluation.find(id)
    end

    def index_params
      params.permit(:clas, :task_id)
    end

    def authorize_evaluation!
      authorize(@evaluation || Evaluation)
    end

    def search_query
      @user_query = User.ransack(params[:query])
      params[:query][:status_eq_any] = Mapper.map_accepted_status(params) if params[:query]&.key?(:status_eq_any)
      @query = Evaluation.ransack(params[:query])
    end

    def set_layout_option
      @active = 'ic-calendar'
      @sub_active = 'Evaluations'
      @heading = 'Manage Evaluations'
      @page = params[:page]
    end

    def update_params
      params.permit(:perform, :date, :flow, evaluation: {}, event: {})
    end

    def show_params
      params.permit(:evaluator_id)
    end

    def date_convert
      zone = ActiveSupport::TimeZone.new(TIME_ZONE)
      @slot = Slot.find(params[:slot_id])
      date = params[:event].delete(:date)
      params[:event][:start_date] =
        (@slot.start_time + (date.to_date - @slot.start_time.to_date).days).in_time_zone(zone)
      params[:event][:end_date] = (@slot.end_time + (date.to_date - @slot.end_time.to_date).days).in_time_zone(zone)
    end

    def accept_evaluation
      add_flash(@evaluation.method(@evaluation.status == 'ready' || update_params[:perform]).call,
                "Evaluation has been #{update_params[:perform]}ed.", "Evaluation was not #{update_params[:perform]}ed.")
    end

    def evaluator_rejection
      add_flash(@evaluation.method(@evaluation.status == 'request' || update_params[:perform]).call,
                'Evaluation has been rejected.', 'Evaluation was not rejected.')
    end

    def set_steps
      self.steps = case update_params[:flow]
                     when 'reject'
                       %i[reject_request update]
                     when 'accept'
                       %i[assign_evaluator assign_event_date update]
                     when 'complete'
                       %i[complete_evaluation update]
                     when 'evaluator_reject'
                       %i[evaluator_reject_request update]
                     when 'detail'
                       %i[evaluation_detail]
                     else
                       %i[history assign_evaluator assign_event_date reject_request complete_evaluation]
                   end
    end

    alias reject_evaluation accept_evaluation
end
