# frozen_string_literal: true

require_relative '../helpers/decorator_helpers'

module Pages
  class LinkedinHomePage
    include Capybara::DSL
    include Helpers

    def initialize
      @language_selector = '//div[contains(@class, "language-selector")]'
      @language_selector_us = '//button[contains(@data-tracking-control-name, "language-selector-en_US")]'
    end

    def move_to_sigh_in
      visit_home_page_linkedin
      change_language
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

    def change_language
      find(:xpath, @language_selector).click; slow_waiting
      find(:xpath, @language_selector_us).click
    end
  end
end
