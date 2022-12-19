# frozen_string_literal: true

require 'faker'

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
puts '-----------------------Creating Default Roles-------------------------'
%i[super_user training_lead training_supervisor buddy trainee evaluator].each do |role|
  Role.where({ name: role, locked: true }, without_protection: true).first_or_create
  print '.'
end
puts "\n"
puts '-------------------------Creating Default Group -------------------------'
Group.create(title: 'default')
puts 'Group Created ............'
puts '-------------------------Creating Super User -------------------------'
puts 'Please add credentials for super user:'
puts "\n"
puts 'Enter name for the super user (enter blank for default: Super User):'
name = gets.chomp
name = 'Super User' if name == ''
puts 'Enter email for the super user (enter blank for default: admin@lnd.com):'
email = gets.chomp
email = 'admin@lnd.com' if email == ''
puts 'Enter password for the super user (enter blank for default: admin123)'
password = gets.chomp
password_confirmation = 'admin123'
if password == ''
  password = password_confirmation
else
  puts 'Enter password again for the super user'
  password_confirmation = gets.chomp
end
user = User.create(name: name, email: email, password: password, password_confirmation: password_confirmation)
puts 'User Created Successfuly!'
puts 'assigning super admin role ...'
user.add_role :super_user
#-------------------------------------
puts 'How many dummy evaluators to create?'
size = gets;
size = size.tr("\n", '')
puts 'add prefix:'
pre = gets.chomp
size.to_i.times do |i|
  user = User.create(name: Faker::Name.name, email: "#{pre}#{i}@gmail.com", password: '111111', password_confirmation: '111111')
  user.add_role :evaluator
  user.save!
  print '.'
end
print "\n"
#-------------------------------------
puts 'How many dummy buddies to create?'
size = gets;
size = size.tr("\n", '')
puts 'add prefix:'
pre = gets.chomp
size.to_i.times do |i|
  user = User.create(name: Faker::Name.name, email: "#{pre}#{i}@gmail.com", password: '222222', password_confirmation: '222222')
  user.add_role :buddy
  user.save!
  print '.'
end
print "\n"
#-------------------------------------
puts 'How many dummy Evaluations to create?'
size = gets;
size = size.tr("\n", '')
size.to_i.times do |i|
  user = User.create(name: Faker::Name.name, email: "number#{pre}#{i}@gmail.com", password: '333333', password_confirmation: '333333')
  user.add_role :trainee
  user.save!
  trid = user.id
  course = Course.create(title: Faker::Book.genre)
  course.save!
  enrollment = Enrollment.create(course_id: course.id, user_id: trid)
  enrollment.save!
  carr = course.id
  section = Section.create(title: Faker::Book.title, days: Faker::Number.number(digits: 2), course_id: carr)
  section.save!
  secid = section.id
  task = Task.create(name: Faker::Book.publisher, duration: Faker::Number.number(digits: 1), section_id: secid)
  task.save!
  evid = User.with_role(:evaluator).ids.sample
  taskid = section.tasks.ids.sample
  enrollmentid = user.enrollments.where(course_id: carr).ids.sample
  evaluation = Evaluation.create(evaluator_id: evid, task_id: taskid, enrollment_id: enrollmentid, status: :ready)
  evaluation.save!
  ev = evaluation.id
  event = Event.create(title: Faker::University.prefix, location: Faker::FunnyName.name, start_date: Faker::Time.forward(days: 23, period: :morning), eventable_id: ev, eventable_type: 'Evaluation', external_id: Faker::Number.number(digits: 1))
  event.save!
  print '.'
end
print "\n"
#-------------------------------------
