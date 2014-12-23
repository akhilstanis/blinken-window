=begin

  This example uses matrix objects to create frames with patterns really fast
  @author Akhil Stanislavose <akhil.stanislavose@gmail.com>

=end

require 'blinken_window/screen'
require './blinken_string'
require 'matrix'

width, height = 6, 10

require 'blinken_window/shifters/terminal_shifter'
screen = BlinkenWindow::Screen.new(width,height, BlinkenWindow::Shifters::TerminalShifter.new(width,height))

# require 'blinken_window/shifters/gpio_shifter'
# screen = BlinkenWindow::Screen.new(width, height, BlinkenWindow::Shifters::GPIOShifter.new(5,4,6))

loop do

  # Random blinks
  50.times do |i|
    screen.paint(Matrix.build(height,width) { rand(2) }.to_a)
    sleep(0.08) # constant speed
    # sleep(0.08 + ((i > 45 ? i : 0) * 0.001)) # slow down to the end
  end

  # Switch on all
  screen.paint(Matrix.build(height, width) { 1 }.to_a)
  sleep(0.5)

  # Switch column by column from left to right
  width.times do |col|
    screen.paint(Matrix.build(height,width) { |r,c| c > col ? 1 : 0 }.to_a)
    sleep(0.04)
  end

  BlinkenString.new('Merry Christmas!').scroll do |frame|
    screen.paint(frame)
    sleep(0.1)
  end

end