# frozen_string_literal: true

require_relative '../helpers/decorator_helpers'

module Pages
  class LoginPage
    include Capybara::DSL
    include Helpers

    def initialize; end

    def input_login_field
      fill_in('username', with: MY_LOGIN)
    end

    def input_password_field
      fill_in('password', with: MY_PASSWORD)
    end

    def sign_in_button_click
      button = page.has_button?('Sign in') ? 'Sign in' : 'Войти'
      click_button(button)
    end

    def sign_in
      puts "User #{MY_LOGIN} sign in"

      [input_login_field, input_password_field].each { |method| slow_waiting_method(method) }
      ordinary_user_behaviour(sign_in_button_click)
    end
  end
end
