# frozen_string_literal: true

VPN_APPLICATION_URL = 'https://www.freeopenvpn.org or https://www.tunnelbear.com/download'

MY_LOGIN = ENV['MY_LOGIN']
MY_PASSWORD = ENV['MY_PASSWORD']
MY_LOCATION = ENV['MY_LOCATION'].nil? ? 'Russia' : ENV['MY_LOCATION']
MY_JOB = ENV['MY_JOB'].nil? ? 'ruby hr' : ENV['MY_JOB']
ADD_NOTE = ENV['ADD_NOTE'].nil? ? false : File.read('./note_for_hr.txt')
