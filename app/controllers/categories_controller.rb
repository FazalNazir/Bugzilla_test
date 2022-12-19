# frozen_string_literal: true

class CategoriesController < ApplicationController
  include CommonConcern
  before_action :paginate_turbo_stream, only: %i[show]
  before_action :alternate_search_query, :search_query

  def show
    @category = Category.find(id)
    @courses = @category.courses.paginate(page: params[:page])
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.create(create_params)
    add_flash(@category.id, 'Category Created successfuly', 'Could not created category.')
  end

  private

    def create_params
      params.require(:category).permit(:title)
    end

    def alternate_search_query
      @query = Course.ransack(params[:query])
    end
end
