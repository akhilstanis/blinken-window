
=begin

  Classic Pong on BlinkenWindow
  @author Akhil Stanislavose <akhil.stanislavose@gmail.com>

  A basic example which introduces writing simple games on blinken window

=end

class Pong
  attr_reader :width, :height, :speed

  def initialize(width=6, height=10, speed=0.5)
    @width, @height, @speed = width, height, speed
  end

  def run
    Thread.new do
      loop { movebat }
    end

    loop do
      break if ball.out?
      moveball
      sleep(speed)
    end
  end

  private

  def bat
    @bat ||= Bat.new(width, height - 1)
  end

  def ball
    @ball ||= ball = Ball.new(bat, {
      :maxx => width,
      :maxy => height,
      :startx => rand(width),
      :starty => rand(height),
    })
  end

  def moveball
    screen.set(ball.x, ball.y, 0)
    ball.move
    screen.set(ball.x, ball.y)
    screen.render
  end

  def movebat
    previos_pixels = bat.pixels.dup
    case Curses.getch
    when 'a'
      bat.moveleft
    when 's'
      bat.moveright
    end
    previos_pixels.each { |p| screen.set(*(p << 0)) }
    bat.pixels.each { |p| screen.set(*p) }
    screen.render
  end

  def screen
    @screen ||= BlinkenWindow::Screen.new(width, height, BlinkenWindow::Shifters::TerminalShifter.new(width, height))
  end

end

class Bat
  def initialize(maxx, y, width=2)
    @maxx  = maxx
    @y = y
    @width = width
  end

  def moveright
    @x = lx + 1 unless rx == @maxx
  end

  def moveleft
    @x = lx - 1 unless lx == 0
  end

  def touch?(nx, ny)
    (nx >= lx && nx <= rx) && ny == @y - 1
  end

  def pixels
    (lx...rx).to_a.collect { |x| [x,@y] }
  end

  private

  def lx
    @x ||= 0
  end

  def rx
    lx + @width
  end
end

class Ball

  attr_reader :bat

  def initialize(bat, settings={})
    @bat = bat
    @settings = {
      :maxx   => 6,
      :maxy   => 10,
      :startx => 0,
      :starty => 0
    }.merge(settings)
  end

  def move
    [movex, movey]
  end

  def x
    @x ||= @settings[:startx]
  end

  def y
    @y ||= @settings[:starty]
  end

  def out?
    y == maxy - 1
  end

  private

  def movex
    @dx =  1 if x == 0
    @dx = -1 if x == maxx - 1
    @x = x + dx
  end

  def movey
    @dy =  1 if y == 0
    @dy = -1 if bat.touch?(x,y)
    @y = y + dy
  end

  def dx
    @dx ||= 1
  end

  def dy
    @dy ||= -1
  end

  def maxx
    @maxx ||= @settings[:maxx]
  end

  def maxy
    @maxy ||= @settings[:maxy]
  end
end

require 'blinken_window/shifters/terminal_shifter'
require 'blinken_window/screen'

puts "Instructions: Press 'a' to move left and 's' to move right.\nPress enter to continue..."
gets

width, height, speed = 6, 10, 0.2
Pong.new(width, height, speed).run
