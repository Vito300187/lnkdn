# frozen_string_literal: true

require 'capybara/rspec'
require 'capybara'
require 'capybara/dsl'
require 'pry'
require 'waitutil'
require 'selenium/webdriver'

Dir.glob('./pages_objects/*.rb', &method(:require))
Dir.glob('./helpers/*.rb', &method(:require))

browser_mode = Capybara.configure do |config|
  config.default_max_wait_time = 10
  config.app_host = 'https://www.linkedin.com'

  if ENV['HEADLESS']
    config.default_driver = :selenium_chrome_headless
    config.javascript_driver = :selenium_chrome_headless
  elsif ENV['SELEN']
    config.default_driver = :remote_chrome
    config.javascript_driver = :remote_chrome
  else
    config.default_driver = :selenium_chrome
    config.javascript_driver = :selenium_chrome
  end
end

check_vpn_work
capybara_configure(browser_mode)

RSpec.configure do |config|
  config.before(:suite) do
    separate; time('Start'); separate
  end

  config.after(:suite) do
    separate; time('End'); separate
  end

  Capybara.page.driver.browser.manage.window.maximize
end
