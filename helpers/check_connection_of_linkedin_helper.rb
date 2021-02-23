# frozen_string_literal: true

require 'uri'
require 'net/http'

def check_vpn_work
  begin
    if Net::HTTP.get_response(URI(Capybara.app_host)).code.eql?('200')
      puts 'Connection with Linkedin is set'
    end
  rescue Net::OpenTimeout, Errno::EADDRNOTAVAIL
    abort("Sorry, but for Linkedin, you need use VPN -> #{VPN_APPLICATION_URL}")
  end
end
