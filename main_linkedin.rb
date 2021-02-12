# frozen_string_literal: true

require_relative 'spec_helpers'

feature 'Test' do
  scenario 'for check connecting people' do
    search_people = Pages::Search::People.new

    Pages::LinkedinHomePage.new.move_to_sigh_in
    Pages::LoginPage.new.sign_in
    Pages::UserHomePage.new.visit_to_nav_link('Jobs')
    Pages::Search::Jobs.new.search_job_and_location
    search_people.choose_location
    search_people.connect_while_hr_available

    puts "Established Connect -> #{search_people.established_connect}"
  end
end
