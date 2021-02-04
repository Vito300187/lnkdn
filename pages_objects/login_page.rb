# frozen_string_literal: true

require_relative '../helpers/decorator_helpers'

module Pages
  class LoginPage
    include Capybara::DSL
    include Helpers

    def initialize
      @login_field_username = 'username'
      @login = "//input[id=#{@login_field_username}]"

      @login_field_password = 'password'
      @password = "//input[id=#{@login_field_password}]"

      @enter_button_name = 'Войти'
      @confirm_button = "//button[contain(text(), #{@enter_button_name}]"
    end

    def input_login_field
      fill_in(@login_field_username, with: MY_LOGIN)
    end

    def input_password_field
      fill_in(@login_field_password, with: MY_PASSWORD)
    end

    def sign_in
      puts "User #{MY_LOGIN} sign in"

      [
        input_login_field,
        input_password_field,
        click_button(@enter_button_name)
      ].each { |fill_in| ordinary_user_behaviour(fill_in)}
    end
  end
end
