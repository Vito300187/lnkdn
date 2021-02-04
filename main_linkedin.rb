# frozen_string_literal: true

require_relative 'spec_helpers'

describe 'Add HR for ruby vacancies' do
  Pages::LinkedinHomePage.new.move_to_sigh_in
  Pages::LoginPage.new.sign_in
  Pages::UserHomePage.new.visit_to_nav_link('Jobs')
  Pages::Search::Jobs.new.search_job_and_location
  Pages::Search::People.new.choose_location
  Pages::Search::People.new.connect_while_hr_available
end
