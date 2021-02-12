# frozen_string_literal: true

require_relative '../helpers/decorator_helpers'

module Pages
  class LinkedinHomePage
    include Capybara::DSL
    include Helpers

    def initialize; end

    def move_to_sigh_in
      visit_home_page_linkedin
      ordinary_user_behaviour(sign_in_button_click)
    end

    def sign_in_button_click
      button = page.has_link?('Sign in') ? 'Sign in' : 'Войти'
      click_link(button)
    end

    def visit_home_page_linkedin
      puts 'Visit Linkedin'

      visit LINKEDIN_HOME_PAGE_URL
    end
  end
end
