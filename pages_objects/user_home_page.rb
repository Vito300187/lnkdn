require_relative '../helpers/decorator_helpers'

module Pages
  class UserHomePage < Logger
    include Capybara::DSL
    include Helpers

    def initialize
    end

    # The method can accept different tabs: 'Home', 'My Network', 'Jobs', 'Messaging', 'Notifications'
    def visit_to_nav_link(nav_link)
      puts "Visit to #{nav_link}"
      click_link(nav_link)
    end
  end
end
