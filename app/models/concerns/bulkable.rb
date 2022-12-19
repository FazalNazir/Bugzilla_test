# frozen_string_literal: true

module Bulkable
  extend ActiveSupport::Concern

  included do
    scope :in_bulk, -> (ids, options = {}) do
      options[:id] = ids.split(',')
      where(options)
    end
  end
end
