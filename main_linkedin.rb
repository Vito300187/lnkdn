# frozen_string_literal: true

require_relative 'spec_helpers'

describe 'Add HR' do
  linkedin_home_page = Pages::LinkedinHomePage.new
  login_page = Pages::LoginPage.new
  user_home_page = Pages::UserHomePage.new
  find_jobs_page = Pages::Search::Jobs.new

  context 'For ruby vacancies' do
    linkedin_home_page.move_to_sigh_in
    login_page.sign_in
    user_home_page.visit_to_nav_link('Jobs')
    find_jobs_page.search_job
  end
end
