# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit::Authorization
  include CommonConcern

  before_action :authenticate_user!, :paginate_turbo_stream, :navbar_options

  def add_flash(condition, msg1, msg2)
    if condition
      flash[:notice] = msg1
    else
      flash[:alert] = msg2
    end
  end

  def paginate_turbo_stream
    @paginate_turbo_stream = LndLinkRenderer.new
    @paginate_turbo_stream.assign_controller(params[:controller])
  end

  def navbar_options
    @options = support_options
  end
end
