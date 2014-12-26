=begin

  This example uses matrix objects to create frames with patterns really fast
  @author Akhil Stanislavose <akhil.stanislavose@gmail.com>

=end

require 'blinken_window/screen'
require './blinken_string'
require 'matrix'

W, H = 6, 10

require 'blinken_window/shifters/terminal_shifter'
SCREEN = BlinkenWindow::Screen.new(W,H, BlinkenWindow::Shifters::TerminalShifter.new(W,H))

# require 'blinken_window/shifters/gpio_shifter'
# SCREEN = BlinkenWindow::Screen.new(W, H, BlinkenWindow::Shifters::GPIOShifter.new(5,4,6))

def all(bit)
  SCREEN.paint(Matrix.build(H, W) { bit }.to_a)
end

def flash(s=0.5)
  all(1)
  sleep(s)
  SCREEN.clear
  sleep(s)
end

def random(s=0.08)
  SCREEN.paint(Matrix.build(H,W) { rand(2) }.to_a)
  sleep(block_given? ? yield : s)
end

def slideright(s=0.04)
  W.times do |col|
    SCREEN.paint(Matrix.build(H,W) { |r,c| c > col ? 1 : 0 }.to_a)
    sleep(s)
  end
end

def slideleft(s=0.04)
  (0...W).reverse_each do |col|
    SCREEN.paint(Matrix.build(H,W) { |r,c| c > col ? 0 : 1 }.to_a)
    sleep(s)
  end
end

def slideup(s=0.04)
  H.times do |row|
    SCREEN.paint(Matrix.build(H,W) { |r,c| r > row ? 1 : 0 }.to_a)
    sleep(s)
  end
end

def slidedown(s=0.04)
  (0...H).reverse_each do |row|
    SCREEN.paint(Matrix.build(H,W) { |r,c| r > row ? 0 : 1 }.to_a)
    sleep(s)
  end
end

def ntoxy(n)
  y = n/6
  x = n - y*6
  [x,y]
end

def snake(width,s=0.02)
  ns = (0..(59-width)).to_a + (0..(59-width)).to_a.reverse

  ns.each do |i|
    SCREEN.clear
    i.upto(i+width) do |j|
      break if j == 0 || j == 60
      SCREEN.set(*ntoxy(j))
    end
    SCREEN.render
    sleep(s)
  end
end


loop do

  # Random blinks
  30.times do |i|
    random(0.08)
    # random { 0.08 + ((i > 45 ? i : 0) * 0.001) # slow down to the end }
  end

  # Switch on all
  all(1)
  sleep(0.5)

  # flash twice
  3.times { flash(0.5) }

  all(1)
  sleep(0.5)

  2.times { snake(32,0.02) }

  20.times { random(0.08) }

  all(1)
  sleep(0.5)

  # Switch column by column from left to right
  slideright(0.07)
  slideleft(0.07)
  slideright(0.07)
  slidedown(0.04)
  slideup(0.04)
  # slidedown(0.04)

  # 5.times { random(0.08) }
  flash(0.4)
  all(1)
  sleep(0.4)
  slideright(0.04)

  BlinkenString.new('Merry Christmas!').scroll do |frame|
    SCREEN.paint(frame)
    sleep(0.08)
  end

end