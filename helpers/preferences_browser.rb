def capybara_configure(mode)
  {
      remote_chrome: Capybara.register_driver(:remote_chrome) do |app|
        caps = Selenium::WebDriver::Remote::Capabilities.chrome
        caps[:browser_name] = 'chrome'
        caps[:version] = chrome_version
        caps['enableVNC'] = true
        caps['goog:chromeOptions'] = { 'args' => %w[--no-sandbox] }
        opts = {
            browser: :remote,
            url: 'http://localhost:4444/wd/hub',
            desired_capabilities: caps
        }
        Capybara::Selenium::Driver.new(app, **opts)
      end,

      selenium_chrome_headless: Capybara.register_driver(:selenium_chrome_headless) do |app|
        caps = Selenium::WebDriver::Remote::Capabilities.chrome
        caps['goog:chromeOptions'] = { 'args' => %w[--headless --no-sandbox] }
        opts = {
            browser: :chrome,
            desired_capabilities: caps
        }
        Capybara::Selenium::Driver.new(app, **opts)
      end,

      selenium_chrome: Capybara.register_driver(:selenium_chrome) do |app|
        Capybara::Selenium::Driver.new(app, browser: :chrome)
      end
  }[mode]
end

def separate
  puts '_'*20
end

def time(p)
  puts "#{p} script #{Time.now.strftime('%d-%m-%Y %H:%M')}"
end

def chrome_version
  `chromedriver -v`.split(' ')
      .reject { |a| a == 'ChromeDriver' }
      .first
      .split('.')[0] << '.0'
end
