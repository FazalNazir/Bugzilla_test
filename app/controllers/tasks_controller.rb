# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :search_query

  def index
    @course = Course.find(index_params[:course_id]) if index_params.key?(:course_id)
    @section = Section.find(index_params[:section_id]) if index_params.key?(:section_id)
    @tasks = index_params.key?(:section_id) ? @section.tasks : @course.tasks.paginate(page: params[:page])
  end

  def new
    @section = Section.find(id)
    @task = @section.tasks.new
  end

  def edit
    @task = Task.includes(:section).find(id)
    @section = @task.section
    render 'new'
  end

  def create
    @task = Task.create(create_update_params)
    add_flash(@task.id, 'Task created successfuly.', 'Task was not created successfuly.')
    @section = @task.section
    @tasks = @section.tasks
    render 'index'
  end

  def update
    @task = Task.includes([:section]).find(id)
    add_flash(@task.update(create_update_params), 'Task updated successfuly.', 'Task was not updated successfuly.')
    @section = @task.section
    @tasks = @section.tasks
    render 'index'
  end

  def destroy
    @task = Task.where(id: id.split(','))
    @section = @task[0].section
    add_flash(@task.destroy_all, 'Task deleted successfuly.', 'Task was not deleted successfuly.')
    @tasks = @section.tasks
    render 'index'
  end

  private

    def id
      params.require(:id)
    end

    def search_query
      @query = Task.ransack(params[:query])
    end

    def create_update_params
      params.require(:task).permit(:name, :section_id, :duration, :description)
    end

    def index_params
      params.permit(:section_id, :course_id)
    end
end
