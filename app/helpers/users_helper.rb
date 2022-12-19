# frozen_string_literal: true

module UsersHelper
  def show_no_users(users)
    return unless users.empty?

    '<div class="h-full w-full jus-c-item-c font-semibold text-[36px]
    leading-[54px] text-slate-400 mt-[10px] mb-[50px]">Ops! No User Found</div>'.html_safe
  end

  def show_pagination(users, paginate)
    return if users.empty?

    "<div class='h-[94px] w-full jus-b-item-c px-[25px] py-[32px] mt-auto' id='filter-pagination'>
    <div class='font-medium text-[14px] leading-[21px] text-[#B5B7C0]'>#{page_entries_info(users)}</div>
    <div>#{will_paginate(users, inner_window: 2, outer_window: 0, renderer: paginate)}</div>
    </div>".html_safe
  end

  def all_unassigned_groups(user)
    Group.where.not(id: user.groups.ids)
  end

  def shortify_role(role)
    name = role.stylize.split(' ')
    shortify = ''
    name.size.times do |i|
      shortify += name[i][0]
      break if i == 1
    end
    shortify
  end

  def first_role(user)
    user.roles.order(id: :asc).first
  end

  def all_but_first_role(user)
    user.roles.order(id: :asc)[1..]
  end

  def all_roles
    Role.where.not(name: :super_user)
  end

  def coma_seperated_roles(user)
    user.roles.pluck(:name).join(',')
  end

  def render_edit_modal(modal, user)
    if modal == 'edit'
      render(partial: 'users/edit_modal', locals: { hidden: false, method: :patch, path: user_path(user) }).html_safe
    else
      render(partial: 'users/add_group_modal').html_safe
    end
  end
end
