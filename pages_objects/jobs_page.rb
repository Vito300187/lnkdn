# frozen_string_literal: true

require_relative '../helpers/decorator_helpers'
require 'nokogiri'
require 'uri'

NUMBER_OF_ATTEMPTS = 10

module Pages
  class Search
    class Jobs
      include Capybara::DSL
      include Helpers

      def initialize
        @messaging_header_chat = '//section[contains(@class, "msg-overlay-bubble-header__details")]'
        @collapse_message_chat = '//div[contains(@class, "list-bubble--is-minimized")]'
        @search_job_field = '//input[contains(@id, "jobs-search-box-keyword-id")]'
        @search_location_field = '//input[contains(@id, "jobs-search-box-location-id")]'
        @select_search_filter = '//ul[contains(@class, "search-vertical-filter__filters-list")]'
        @select_search_filter_list = '//li[contains(@class, "search-vertical-filter__dropdown-list-item")]'
      end

      def collapse_message_chat
        find(:xpath, @messaging_header_chat).click if chat_expand?
      end

      def chat_expand?
        page.has_no_xpath?(@collapse_message_chat)
      end

      def search_job(job = MY_JOB, location = MY_LOCATION)
        collapse_message_chat

        [
          find(:xpath, @search_job_field).set(job),
          find(:xpath, @search_location_field).set(location).send_keys(:return)
        ].each { |action| ordinary_user_behaviour(action); sleep 3 }

        ordinary_user_behaviour(
          change_filter_jobs_to('People')
        )

        WaitUtil.wait_for_condition(
          '',
          timeout_sec: 10,
          delay_sec: 3
        ) { page.has_no_xpath?(@select_search_filter_list) }
      end

      def change_filter_jobs_to(item)
        find(:xpath, @select_search_filter).click

        content_index = all(:xpath, @select_search_filter_list).index { |i| i.text.eql?(item) }
        all(:xpath, @select_search_filter_list)[content_index].click
      end
    end

    class People
      def initialize
        @select_my_location = '//span[contains(@class, "search-typeahead-v2__hit-info")]'
        @location_button_name = 'Locations'
        @show_result_button_name = 'Show results'
        @search_result = '//div[contains(@class, "search-results-page")]/div[contains(@class, "black--light")]'
        @found_people_table = '//div[contains(@class, "search-results-container")]//li[contains(@class, "reusable-search__result-container ")]'
        @add_a_note_textarea = '//textarea[contains(@id, "custom-message")]'
        @make_a_contact = '//div[contains(@class, "entity-result__item")]//button'
        @add_a_note_button_name = 'Add a note'
        @connect_button_name = 'Connect'
        @send_connect_button_name = 'Send'
      end

      def choose_location
        click_button(@location_button_name)
        fill_in('Add a location', with: MY_LOCATION)

        index = all(:xpath, @select_my_location).index { |i| i.text.eql?(MY_LOCATION) }
        all(:xpath, @select_my_location)[index].click
        click_button(@show_result_button_name)
      end

      def add_a_cover_letter
        click_button(@add_a_note_button_name)
        find(:xpath, @add_a_note_textarea).set(add_a_note)
        click_button(@send_connect_button_name)
      end

      def connect_with_hr(add_a_note = nil)
        send_connect_count = 0
        NUMBER_OF_ATTEMPTS.times do
          all(:xpath, @make_a_contact).each do |button_connect|
            next unless button_connect.text.eql?(@connect_button_name)

            binding.pry
            button_connect.click
            add_a_cover_letter unless add_a_note.nil?
            click_button(@send_connect_button_name)
            send_connect_count += 1

            WaitUtil.wait_for_condition(
              'Connect button change to Pending',
              timeout_sec: 10,
              delay_sec: 1
            ) { button_connect.text.eql?('Pending') }
          end
          pagination('Next')
        end
        puts "Today send #{send_connect_count.sum} invitations"
      end

      def results_count_on_page
        find(:xpath, @search_result).text.to_i
      end

      # click_button('Next') or # click_button('Previous')
      def pagination(action)
        # binding.pry
        # Кликать, если только кнопка активна, в противном случае, выходить из программы
        click_button(action)
      end
    end
  end
end
