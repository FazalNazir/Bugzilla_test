# frozen_string_literal: true

require 'cgi'
module EvaluationsHelper
  def update_selection_path(task, perform)
    return if perform == 'filter'

    if task
      turbo_stream.update('evaluation-path') do
        "<div class='ic-drop-down w-[25px] h-[25px] bg-cover -rotate-90'></div><span>#{task.name}</span>".html_safe
      end
    else
      turbo_stream.update('tasks-path') do
        "Evaluation<div class='ic-drop-down w-[25px] h-[25px] bg-cover -rotate-90'>
        </div><span>Requests</span>".html_safe
      end
    end.html_safe
  end

  def hide_search_bar(clas, perform)
    return unless clas == 'request' && perform != 'filter'

    turbo_stream.replace('search-container').html_safe
  end

  def hide_reqest_button(clas, perform)
    return unless clas == 'request' && perform != 'filter'

    turbo_stream.replace('request-btn').html_safe
  end

  def show_filters_button(clas, perform, query)
    return unless clas == 'request' && perform != 'filter'

    turbo_stream.update('select-options') do
      render partial: 'filters_button', locals: { query: query }
    end.html_safe
  end

  def hide_selected_task_container(perform)
    return unless perform != 'filter'

    turbo_stream.replace('selected-task-container').html_safe
  end

  def show_months(ind)
    return unless (DateTime.now + (ind - 1).day).strftime('%B') != (DateTime.now + ind.day).strftime('%B')

    "<div class='w-full relative text-center text-[12px]
    #{ind.zero? ? 'text-blue-700 dark:text-blue-700' : 'dark:text-white'}'>
      <span class='absolute left-[-28px] top-[-11px] w-[35px] rounded-full px-[3px] bg-blue-700 text-white'>
      #{(DateTime.now + ind.day).strftime('%b')}</span>
    </div>".html_safe
  end

  def show_days
    str = ''

    31.times do |i|
      condition = (DateTime.now + (i - 1).day).strftime('%B') != (DateTime.now + i.day).strftime('%B')
      str += "<div class='w-[70px] #{condition ? 'border-l-blue-700 border-l-[1px]' : ''} flex-col jus-c-item-c
      px-[10px] hover:bg-slate-200 dark:hover:bg-slate-800 py-[5px] cursor-pointer'
      data-value='#{(DateTime.now + i.day).strftime('%F')}' data-action='click->modal#assignDate'>
        #{show_months(i)}
        <div class='w-full text-center text-[12px] #{i.zero? ? 'text-blue-700 dark:text-blue-700' : 'dark:text-white'}'>
          #{(DateTime.now + i.day).strftime('%a')}
        </div>
        <div class='w-[70px] text-[32px] text-center
        #{i.zero? ? 'text-blue-700 dark-text-blue-700' : 'dark:text-white'}'> #{(DateTime.now + i.day).strftime('%d')}
        </div>
      </div>"
    end

    str.html_safe
  end

  def render_modal(modal)
    if modal == 'evaluator'
      render(partial: 'requests/assign_evaluator_modal', locals: { evaluation: true }).html_safe
    else
      render(partial: 'requests/assign_evaluation_date_modal', locals: { evaluation: true }).html_safe
    end
  end

  def show_slots(evaluator, date)
    options = ''
    evaluator.all_time_slots(date).each do |slot|
      options += "<option value='#{slot[:slot_id]}'>#{slot[:slot]}</option>"
    end

    options.html_safe
  end

  def get_task(task_id)
    Task.find(task_id)
  end

  def evaluation_event(evaluation)
    evaluation.event
  end

  def get_user(evaluation)
    evaluation.enrollment.user
  end

  def show_action(evaluation)
    if evaluation.status != 'request'
      return render partial: 'show_evaluator_action',
                    locals: { evaluation: evaluation }
    end

    "<td><div class='w-full jus-c-item-c text-red-700'>rejected</div></td>".html_safe
  end

  def role_base_check_box
    return render partial: 'shared/evaluator_filter_options' if current_user.has_role?(:evaluator)

    render partial: 'shared/admin_filter_options' if current_user.has_role?(:super_user)
  end

  def role_base_turbo
    return render partial: 'evaluations/evaluator_evaluations_turbo' if current_user.has_role?(:evaluator)

    render partial: 'evaluations/admin_evaluations_turbo' if current_user.has_role?(:super_user)
  end
end
