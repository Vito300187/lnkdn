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

Capybara.register_driver :remote_chrome do |app|
  caps = Selenium::WebDriver::Remote::Capabilities.chrome
  caps[:browser_name] = 'chrome'
  caps[:version] = '88.0'
  caps['enableVNC'] = true
  opts = {
    browser: :remote,
    url: 'http://localhost:4444/wd/hub',
    desired_capabilities: caps
  }
  Capybara::Selenium::Driver.new(app, opts)
end

Capybara.configure do |config|
  config.default_driver = ENV['SELEN'] ? :remote_chrome : :selenium_chrome
  config.javascript_driver = ENV['SELEN'] ? :remote_chrome : :selenium_chrome
  config.default_max_wait_time = 10
end

RSpec.configure { Capybara.page.driver.browser.manage.window.maximize }
