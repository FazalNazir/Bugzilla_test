# frozen_string_literal: true

require 'will_paginate/view_helpers/action_view'

class LndLinkRenderer < WillPaginate::ActionView::LinkRenderer
  include Rails.application.routes.url_helpers

  def page_number(page)
    if page == current_page
      tag(:em, page, 'data-turbo-stream': 'true', class: 'current')
    else
      link(page, page, 'data-turbo-stream': 'true')
    end
  end

  def assign_controller(controller)
    @link_controller = controller
  end

  def previous_page
    num = @collection.current_page > 1 && (@collection.current_page - 1)
    previous_or_next_page(num, @options[:previous_label], 'previous_page')
  end

  def next_page
    num = @collection.current_page < total_pages && (@collection.current_page + 1)
    previous_or_next_page(num, @options[:next_label], 'next_page')
  end

  def previous_or_next_page(page, text, classname)
    link(text, page, 'data-turbo-stream': 'true', class: classname)
  end

  private

    def link(text, target, attributes = {})
      if target.is_a?(Integer)
        attributes[:rel] = rel_value(target)
        target = url_for(controller: @link_controller, action: :index, page: target, only_path: true)
      end
      target ||= '#'
      attributes[:href] = target
      tag(:a, text, attributes)
    end
end
