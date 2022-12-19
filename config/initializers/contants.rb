# frozen_string_literal: true

TAGS = %w[turbo-stream template button input form span div table tr td th tbody thead select options a].freeze
ATTRIBUTES = %w[action target class data-action id data-turbo-stream accept-charset method type name value autocomplete data-disable-with].freeze
APPROVED = %w[ready evaluated re_evaluated done].freeze
TRAINEE_OPTIONS = [
  {
    icon: 'ic-dashboard',
    name: 'Dashboard'
  },
  {
    icon: 'ic-logout',
    name: 'Logout'
  }
].freeze
SUPER_USER_OPTIONS = [
  TRAINEE_OPTIONS[0],
  {
    icon: 'ic-user',
    name: 'Manage User'
  },
  {
    icon: 'ic-calendar',
    name: 'Training'
  },
  {
    icon: 'ic-briefcase',
    name: 'Lorem'
  },
  {
    icon: 'ic-down',
    name: 'Lorem'
  },
  {
    icon: 'ic-gear',
    name: 'Settings'
  },
  TRAINEE_OPTIONS[1]
].freeze

TRAINER_OPTIONS = [
  TRAINEE_OPTIONS[0],
  {
    icon: 'ic-user',
    name: 'Evaluations'
  },
  {
    icon: 'ic-down',
    name: 'Lorem'
  },
  TRAINEE_OPTIONS[1]
].freeze

FILTER_ROLES = {
  'new_sync' => %i[trainee training_supervisor]
}.freeze
TIME_ZONE = 'Asia/Karachi'
