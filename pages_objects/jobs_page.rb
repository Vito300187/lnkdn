# frozen_string_literal: true

require_relative '../helpers/decorator_helpers'

module Pages
  class Search
    class Jobs
      include Capybara::DSL
      include Helpers

      def initialize
        @collapse_message_chat = '//div[contains(@class, "list-bubble--is-minimized")]'
        @messaging_header_chat = '//section[contains(@class, "msg-overlay-bubble-header__details")]'
        @search_job_field = '//input[contains(@id, "jobs-search-box-keyword-id")]'
        @search_location_field = '//input[contains(@id, "jobs-search-box-location-id")]'
        @select_search_filter = '//ul[contains(@class, "search-vertical-filter__filters-list")]'
        @select_search_filter_list = '//li[contains(@class, "search-vertical-filter__dropdown-list-item")]'
      end

      def collapse_message_chat
        if chat_expand?
          puts 'Collapse message chat'

          ordinary_user_behaviour(
            find(:xpath, @messaging_header_chat).click
          )
        end
      end

      def chat_expand?
        page.has_no_xpath?(@collapse_message_chat)
      end

      def search_job(job = MY_JOB)
        puts "Search job #{MY_JOB}"

        ordinary_user_behaviour(
          find(:xpath, @search_job_field).set(job)
        )
      end

      def search_location(location = MY_LOCATION)
        puts "Search location #{MY_LOCATION}"

        ordinary_user_behaviour(
          find(:xpath, @search_location_field).set(location).send_keys(:return)
        )
      end

      def change_filter_jobs_to(item)
        find(:xpath, @select_search_filter).click
        content_index = all(:xpath, @select_search_filter_list).index { |i| i.text.eql?(item) }

        ordinary_user_behaviour(
          all(:xpath, @select_search_filter_list)[content_index].click
        )
      end

      def search_job_and_location
        collapse_message_chat
        [
          search_job,
          search_location,
          change_filter_jobs_to('People')
        ].each { |action| ordinary_user_behaviour(action) }

        puts "Found #{Pages::Search::People.new.results_count_on_page} HR"

        WaitUtil.wait_for_condition(
          '',
          timeout_sec: 10,
          delay_sec: 3
        ) { page.has_no_xpath?(@select_search_filter_list) }
      end
    end

    class People
      include Capybara::DSL
      include Helpers

      attr_accessor :established_connect

      def initialize
        @add_a_note_button_name = 'Add a note'
        @add_a_note_textarea = '//textarea[contains(@id, "custom-message")]'
        @connect_button_name = 'Connect'
        @established_connect = 0
        @found_people_table = '//div[contains(@class, "search-results-container")]//li[contains(@class, "reusable-search__result-container ")]'
        @location_button_name = 'Locations'
        @make_a_contact = '//div[contains(@class, "entity-result__item")]//button'
        @next_button_name = 'Next'
        @non_active_pending_button = '//button[contains(., "Pending")]'
        @people_name = '//span[contains(@class, "entity-result__title-text")]//span[@aria-hidden]'
        @select_my_location = '//span[contains(@class, "search-typeahead-v2__hit-info")]'
        @send_connect_button_name = 'Send'
        @search_result = '//div[contains(@class, "search-results-page")]/div[contains(@class, "black--light")]'
        @show_result_button_name = 'Show results'
      end

      def choose_location
        puts 'Choosing my location'

        click_button(@location_button_name)
        fill_in('Add a location', with: MY_LOCATION)

        index = all(:xpath, @select_my_location).index { |i| i.text.include?(MY_LOCATION) }
        ordinary_user_behaviour(
          all(:xpath, @select_my_location)[index].click
        )
        click_button(@show_result_button_name)

        WaitUtil.wait_for_condition(
          'Location found on page',
          timeout_sec: 10,
          delay_sec: 1
        ) { page.has_button?(MY_LOCATION) }
      end

      def add_a_cover_letter
        puts 'Add a cover letter'

        click_button(@add_a_note_button_name)
        ordinary_user_behaviour(
          find(:xpath, @add_a_note_textarea).set(ADD_NOTE)
        )
      end

      def add_note_for_connect
        if ADD_NOTE
          ordinary_user_behaviour(add_a_cover_letter)
          click_button(@send_connect_button_name)
        end
      end

      def pending_button_on_page
        all(:xpath, @non_active_pending_button).count
      end

      def name_hr(index)
        all(:xpath, @people_name)[index].text
      end

      def connect_with_hr
        all(:xpath, @make_a_contact).each do |button_connect|
          next unless button_connect.text.eql?(@connect_button_name)

          pending_button_on_page_before = pending_button_on_page
          button_connect.click; sleep 3
          add_note_for_connect
          ordinary_user_behaviour(
            click_button(@send_connect_button_name)
          )

          if weekly_invitation_limit? || connection_problem?
            abort('Sorry, but connection is closed, try after 1 hour')
          end

          WaitUtil.wait_for_condition(
            'Connect button change to Pending',
            timeout_sec: 10,
            delay_sec: 1
          ) { pending_button_on_page.eql?(pending_button_on_page_before + 1) }

          puts 'Connect is set'; self.established_connect += 1
        end

        ordinary_user_behaviour(
          click_pagination(@next_button_name)
        )
      end

      def connect_while_hr_available
        puts 'Connect with HR'

        while pagination_button_active?(@next_button_name) || page_has_connect_buttons
          ordinary_user_behaviour(connect_with_hr)
        end

        puts "Work ended, added #{@established_connect} people"
      end

      def connection_problem?
        page.has_text?('Your connection request couldn’t be completed right now. Please try again later.')
      end

      def weekly_invitation_limit?
        page.has_text?('You’ve reached the weekly invitation limit')
      end

      def page_has_connect_buttons
        puts 'Checking available people to connect'

        all(:xpath, @make_a_contact).any? { |button_connect| button_connect.text.eql?(@connect_button_name) }
      end

      def results_count_on_page
        parse_result = find(:xpath, @search_result).text.delete(',')
        /[[:digit:]]+/.match(parse_result).to_s
      end

      def click_pagination(action)
        pagination_button_active?(action) ? (puts "Click pagination button #{action}"; click_button(action)): false
      end

      def pagination_button_active?(action)
        [scroll_page_to(:down), scroll_page_to(:up)].each { |_| _ }
        find(:xpath, "//button[contains(@aria-label, '#{action}')]").disabled? ? false : true
      end
    end
  end
end
