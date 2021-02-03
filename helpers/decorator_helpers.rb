require_relative '../spec_helper'

SPEED_OF_USER_MOUSE = 0.5

module Helpers
  def ordinary_user_behaviour(methods)
    mouse_move
    methods
  end

  def speed_of_user_behavior
    sleep rand(2.0..5.0)
  end

  def mouse_move
    speed_of_user_behavior
    custom_mouse_movement
  end

  # optionally specify how long it should take the mouse to move
  def custom_mouse_movement
    Mouse.move_to [
                    rand(100..800),
                    rand(100..800)
                  ],
                  SPEED_OF_USER_MOUSE
  end
end
