# frozen_string_literal: true

require 'capybara/rspec'
require 'capybara'
require 'capybara/dsl'
require 'pry'
require 'waitutil'
require 'selenium/webdriver'

Dir.glob('./pages_objects/*.rb', &method(:require))
Dir.glob('./helpers/*.rb', &method(:require))

check_vpn_work

Capybara.default_driver = ENV['HEADLESS'] ? :selenium_chrome_headless : :selenium_chrome
Capybara.reset_sessions!

RSpec.configure do
  session_window = Capybara.page.driver.browser.manage.window
  ENV['HEADLESS'] ? session_window.resize_to(1920, 1080) : session_window.maximize
end
