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

    def sign_in
      puts "User #{MY_LOGIN} sign in"

      [
        fill_in(@login_field_username, with: MY_LOGIN),
        fill_in(@login_field_password, with: MY_PASSWORD),
        click_button(@enter_button_name)
      ].each { |fill_in| ordinary_user_behaviour(fill_in); sleep 3 }
    end
  end
end
