# frozen_string_literal: true

require_relative '../helpers/decorator_helpers'

module Pages
  class LinkedinHomePage
    include Capybara::DSL
    include Helpers

    def initialize
      @enter_button_name = 'Войти'
      @control_cookies_button_text = 'Управлять настройками'
      @policy_cookies_button_text = 'Политика использования файлов cookie'
      @access_cookies_button_text = 'Принять файлы cookie'
      @enter = "//a[contains(text(), '#{@enter_button_name}')]"
      @access_cookies_button_xpath = "//button[contains(text(), '#{@access_cookies_button_text}')]"
      @policy_cookies_button_xpath = "//p[contains(text(), '#{@policy_cookies_button_text}')]"
    end

    def move_to_sigh_in
      [
        visit_home_page_linkedin,
        click_link(@enter_button_name)
      ].each { |method| ordinary_user_behaviour(method); sleep 3 }
    end

    def visit_home_page_linkedin
      puts 'Visit Linkedin'
      visit LINKEDIN_HOME_PAGE_URL

      if page.has_xpath?(@access_cookies_button_xpath)
        click_button(@control_cookies_button_text)

        WaitUtil.wait_for_condition(
          "Page has text -> #{@policy_cookies_button_text}",
          timeout_sec: 5,
          delay_sec: rand(1..3)
        ) { find(:xpath, @policy_cookies_button_xpath).visible? }

        go_back

        WaitUtil.wait_for_condition(
          "Page has no text -> #{@policy_cookies_button_text}",
          timeout_sec: 5,
          delay_sec: rand(1..3)
        ) { page.has_no_xpath?(@access_cookies_button_xpath) }
      end
    end
  end
end
