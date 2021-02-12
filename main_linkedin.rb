# frozen_string_literal: true

require_relative 'spec_helpers'

feature 'Test' do
  let(:home_page) {Pages::LinkedinHomePage.new}
  let(:login_page) {Pages::LoginPage.new}
  let(:user_home_page) {Pages::UserHomePage.new}
  let(:search_job_page) {Pages::Search::Jobs.new}
  let(:search_people) {Pages::Search::People.new}

  scenario 'for check connecting people' do
    home_page.move_to_sigh_in
    login_page.sign_in
    user_home_page.visit_to_nav_link('Jobs')
    search_job_page.search_job_and_location
    search_people.choose_location
    search_people.connect_while_hr_available

    puts "Established Connect -> #{search_people.established_connect}"
  end
end
