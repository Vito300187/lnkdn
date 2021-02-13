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
  config.default_driver = ENV['SELEN'] ? :remote_chrome : :selenium_chrome_headless
  config.javascript_driver = ENV['SELEN'] ? :remote_chrome : :selenium_chrome_headless
  config.default_max_wait_time = 10
end

def separate
  puts '_'*20
end

def time(p)
  puts "#{p} script #{Time.now.strftime('%d-%M-%Y %H:%M')}"
end

RSpec.configure do |config|
  config.before(:suite) do
    separate; time('Start'); separate
  end

  config.after(:suite) do
    separate; time('End'); separate
  end

  Capybara.page.driver.browser.manage.window.maximize
end
