# frozen_string_literal: true

require 'capybara/rspec'
require 'capybara'
require 'capybara/dsl'
require 'pry'
require 'waitutil'
require 'selenium/webdriver'

Dir.glob('./pages_objects/*.rb', &method(:require))
Dir.glob('./helpers/*.rb', &method(:require))

def separate
  puts '_'*20
end

def time(p)
  puts "#{p} script #{Time.now.strftime('%d-%m-%Y %H:%M')}"
end

def record_video?
  ENV['RECORD_VIDEO'].nil? ? false : true
end

def browser_version
  `chromedriver -v`
    .split(' ')
    .reject { |a| a.include?('Chrome') }[0]
    .to_f
    .to_s
end

Capybara.configure do |config|
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
  config.default_max_wait_time = 10
  config.app_host = 'https://www.linkedin.com'
end

check_vpn_work

Capybara.register_driver :remote_chrome do |app|
  caps = Selenium::WebDriver::Remote::Capabilities.chrome
  caps[:browser_name] = 'chrome'
  caps[:version] = browser_version
  caps['enableVNC'] = true
  caps['enableVideo'] = record_video?
  # caps['videoName'] = 'example_name'
  # caps['videoScreenSize'] = string
  # caps['screenResolution'] = <width>x<height>x<colors-depth>
  # caps['videoFrameRate'] = '24'
  opts = {
    browser: :remote,
    url: 'http://localhost:4444/wd/hub',
    desired_capabilities: caps
  }
  Capybara::Selenium::Driver.new(app, **opts)
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
