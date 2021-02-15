# frozen_string_literal: true

require_relative '../spec_helpers'

module Helpers
  def ordinary_user_behaviour(method)
    scroll_page; slow_waiting_method(method)
  end

  def slow_waiting
    sleep rand(1..4)
  end

  def slow_waiting_method(method)
    slow_waiting; method; slow_waiting
  end

  def scroll_page
    smooth_scrolling_down
    scroll_page_to(:up)
  end

  def smooth_scrolling_down
    puts 'Smooth scrolling down'

    slow_waiting_method(
      0.step(10_000, 20) { |v| page.execute_script "window.scrollTo(0, #{v})"; sleep 0.00001 }
    )
  end

  def scroll_page_to(action)
    puts "Scroll to #{action.to_s} page"

    value = { up: -10_000, down: 10_000 }[action]

    slow_waiting_method(
      page.execute_script "window.scrollTo(0, #{value})"
    )
  end
end
