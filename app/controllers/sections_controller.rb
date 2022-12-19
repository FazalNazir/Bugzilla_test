# frozen_string_literal: true

class SectionsController < ApplicationController
  before_action :set_course, only: :create
  before_action :search_query

  def show
    @section = Section.find(id)
    @next = Section.where('id > ?', id).order(id: :asc).first
    @previous = Section.where('id < ?', id).order(id: :desc).first
  end

  def new
    @course = Course.find(params[:id])
    @section = @course.sections.new
  end

  def edit
    @section = Section.find(id)
  end

  def create
    @section = Section.create(create_params)
    add_flash(@section.id, 'Section Created successfuly', 'Could not created section.')
    @sections = @section.course.sections
  end

  def update
    @section = Section.find(id)
    add_flash(@section.update(update_params), 'Section updated successfuly', 'Could not updated section.')
    @sections = @section.course.sections
    render 'create'
  end

  def destroy
    @section = Section.where(id: id.split(','))
    @sections = @section.first.course.sections
    @section.destroy_all
    add_flash(@section.destroy_all, 'Section deleted successfuly', 'Could not deleted section.')
    render 'create'
  end

  def filter
    @sections = @query.result(distinct: true)
    render 'create'
  end

  private

    def create_params
      params.require(:section).permit(:title, :description, :course_id, :days)
    end

    def set_course
      @course = Course.find(create_params.delete(:course_id))
    end

    def update_params
      params.require(:section).permit(:title, :description, :days)
    end

    def id
      params.require(:id)
    end

    def search_query
      @query = Section.ransack(params[:query])
    end
end
