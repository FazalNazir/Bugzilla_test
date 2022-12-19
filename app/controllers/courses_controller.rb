# frozen_string_literal: true

class CoursesController < ApplicationController
  include CommonConcern
  before_action :search_query, :alternate_search_query
  before_action :set_all_courses, only: :index
  before_action :set_courses, only: :edit

  def index
    @active = 'ic-calendar'
    @sub_active = 'Content'
    @heading = 'Manage Training'
    @page = params[:page]
    @categories = Category.all
  end

  def show
    @active = 'ic-calendar'
    @sub_active = 'Content'
    @action = 'course-show'
    @course = Course.find(params[:id])
    @heading = @course.categories.first.title
    @sections = @course.sections.with_all_rich_text
  end

  def new
    @course = Course.new
  end

  def edit
    @action = edit_params[:perform]
    @ids = id
    @groups = Group.all
    @users = User.all
  end

  def create
    @category = Category.find(create_params[:category_id])
    @course = @category.courses.create(title: create_params[:course][:title], created_by: current_user.name)
    @courses = @category.courses
    add_flash(@course.id, 'Course Created successfuly', 'Could not created course.')
  end

  def filter
    @from = filter_params.key?(:from) ? filter_params[:from] : nil
    if @from.nil?
      ids = params&.[](:query) && ((params[:query][:title_cont] != '' && Course.associated_projects(@query
        .result(distinct: true).select(:id))) || Course.none)
      @category_ids = ids ? ids.pluck(:category_id) : []
    else
      @category = Category.find(filter_params[:parent_id])
      @courses = @query.result(distinct: true)
    end
  end

  def update
    @course = Course.find(id)
    @course.update(update_params)
  end

  def destroy
    @course = Course.where(id: id.split(','))
    @category = Category.find(destroy_params[:category_id])
    @course.destroy_all
    add_flash(@course.destroy_all, 'Course destroyed successfuly', 'Could not destroyed course.')
    @courses = @category.courses
  end

  private

    def set_all_courses
      @courses = @query.result(distinct: true).paginate(page: params[:page])
    end

    def set_courses
      @courses = Course.where(id: edit_params[:ids].split(',')) if params.key?(:ids)
    end

    def edit_params
      params.permit(:perform)
    end

    def create_params
      params.permit(:category_id, course: {})
    end

    def alternate_search_query
      @user_query = User.ransack(params[:query])
    end

    def filter_params
      params.permit(:from, :parent_id)
    end

    def destroy_params
      params.permit(:category_id)
    end

    def update_params
      params.require(:course).permit(:title)
    end
end
