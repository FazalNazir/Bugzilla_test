# frozen_string_literal: true

class EnrollmentsController < ApplicationController
  before_action :search_query

  def index
    @course = Course.find(id)
    @enrollments = @course.enrollments.paginate(page: params[:page])
  end

  def new
    @ids = id
    @courses = Course.find(id.split(','))
    @groups = Group.all
    @users = User.all
  end

  def edit
    @enrollment = Enrollment.find(id)
  end

  def create
    @courses = Course.where(id: create_params[:course_ids].split(','))
    @users = User.where(id: create_params[:user_ids].split(','))
    @start_date = DateTime.strptime(create_params[:start_date], '%Y-%m-%d, %I:%M %p')
    Enrollment.create(Mapper.enrollment_mapping(@users, @courses, @start_date))
  end

  def update
    @start_date = DateTime.strptime(update_params[:start_date], '%Y-%m-%d, %I:%M %p')
    @enrollment = Enrollment.find(id)
    @enrollment.update(start_date: @start_date, due_date: @start_date + @enrollment.course.duration.days)
    @enrollments = @enrollment.course.enrollments
  end

  def destroy
    @enrollment = Enrollment.where(id: id.split(','))
    @enrollments = @enrollment.first.course.enrollments
    @enrollment.destroy_all
    render 'update'
  end

  def filter
    @enrollments = @query.result(distinct: true)
  end

  private

    def id
      params.require(:id)
    end

    def search_query
      @query = Enrollment.ransack(params[:query])
      @course_query = Course.ransack(params[:query])
      @user_query = User.ransack(params[:query])
    end

    def create_params
      params.permit(:course_ids, :user_ids, :start_date)
    end

    def update_params
      params.require(:enrollment).permit(:start_date)
    end
end
