# frozen_string_literal: true

require_relative 'spec_helpers'


linkedin_home_page = Pages::LinkedinHomePage
login_page = Pages::LoginPage
user_home_page = Pages::UserHomePage
search_jobs = Pages::Search::Jobs
search_people = Pages::Search::People

linkedin_home_page.new.move_to_sigh_in
login_page.new.sign_in
user_home_page.new.visit_to_nav_link('Jobs')
search_jobs.new.search_job_and_location
search_people.new.choose_location
search_people.new.connect_while_hr_available

puts "Established Connect -> #{search_people.established_connect}"