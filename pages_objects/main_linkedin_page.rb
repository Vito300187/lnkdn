# frozen_string_literal: true

require_relative '../helpers/decorator_helpers'

module Pages
  class LinkedinHomePage
    include Capybara::DSL
    include Helpers

    def initialize
      @access_cookies_button_text = 'Принять файлы cookie'
      @access_cookies_button_xpath = "//button[contains(text(), '#{@access_cookies_button_text}')]"
      @control_cookies_button_text = 'Управлять настройками'
      @enter_button_name = 'Войти'
      @enter = "//a[contains(text(), '#{@enter_button_name}')]"
      @policy_cookies_button_text = 'Политика использования файлов cookie'
      @policy_cookies_button_xpath = "//p[contains(text(), '#{@policy_cookies_button_text}')]"
    end

    def move_to_sigh_in
      [
        visit_home_page_linkedin,
        click_link(@enter_button_name)
      ].each { |method| ordinary_user_behaviour(method) }
    end

    def preferences_cookies_button?
      page.has_xpath?(@access_cookies_button_xpath)
    end

    def go_back_previous_page
      puts 'Go back previous page'

      ordinary_user_behaviour(go_back)
    end

    def visit_home_page_linkedin
      puts 'Visit Linkedin'

      visit LINKEDIN_HOME_PAGE_URL
      if preferences_cookies_button?
        click_button(@control_cookies_button_text)

        WaitUtil.wait_for_condition(
          "Page has text -> #{@policy_cookies_button_text}",
          timeout_sec: 10,
          delay_sec: 3
        ) { find(:xpath, @policy_cookies_button_xpath).visible? }

        go_back_previous_page

        WaitUtil.wait_for_condition(
          "Page has no text -> #{@policy_cookies_button_text}",
          timeout_sec: 10,
          delay_sec: 3
        ) { page.has_no_xpath?(@access_cookies_button_xpath) }
      end
    end
  end
end
