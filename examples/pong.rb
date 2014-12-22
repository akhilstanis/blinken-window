
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
    yield self if block_given?

    loop do
      break if ball.out?
      moveball
      sleep(speed)
    end

    screen.clear
  end

  def movebat(dir)
    previos_pixels = bat.pixels.dup
    dir == 'left' ? bat.moveleft : bat.moveright
    previos_pixels.each { |p| screen.set(*(p << 0)) }
    bat.pixels.each { |p| screen.set(*p) }
    screen.render
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


  def screen
    @screen ||= BlinkenWindow::Screen.new(width, height, BlinkenWindow::Shifters::TerminalShifter.new(width, height))
  end

end

class Bat
  def initialize(maxx, y, width=1)
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
    (nx >= lx && nx < rx) && ny == @y - 1
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

# Control using input from terminal
# puts "Instructions: Press 'a' to move left and 's' to move right.\nPress enter to continue..."
# gets

# width, height, speed = 6, 10, 0.5
# Pong.new(width, height, speed).run do |pong|
#   Thread.new do
#     loop do
#       case Curses.getch
#       when 'a'
#         pong.movebat('left')
#       when 's'
#         pong.movebat('right')
#       end
#     end
#   end
# end

# Control using web interface
require 'sinatra'
require 'sinatra-websocket'

set :server, 'thin'
set :bind, '0.0.0.0'
set :sockets, []
set :logging, false # Terminal emulator works best when logging if off

class PongManager
  def initialize
    width, height, speed = 6, 10, 0.5
    @pong = Pong.new(width, height, speed)

    Thread.new { @pong.run }
  end

  def process(msg)
    case msg
    when /left/
      @pong.movebat('left')
    when /right/
      @pong.movebat('right')
    end
  end
end

set :pong, nil


get '/' do
  if !request.websocket?
    settings.pong = PongManager.new
    erb :index
  else
    request.websocket do |ws|
      ws.onopen do
        settings.sockets << ws
      end

      ws.onmessage do |msg|
        settings.pong.process(msg)
      end

      ws.onclose do
        settings.sockets.delete(ws)
      end
    end
  end
end

__END__
@@ index
<html>
  <head>
    <meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;">
    <style>
      table { width: 100%; height: 100%; }
      table td { width: 50%; height: 100%; border: #ccc 1px solid; text-align: center; vertical-align: middle; font-size: 500%; }
      .press { background: #ccc; }
    </style>
    <script src="http://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>
    <script>
      $(function(){
        var ws = new WebSocket('ws://' + window.location.host + window.location.pathname);

        $('.btn').on('touchstart', function(){
          $(this).addClass('press');
          ws.send($(this).attr('id'));
        });

        $('.btn').on('touchend', function(){
          $(this).removeClass('press');
        });
      });
    </script>
  </head>
  <body>
    <div>
      <table>
        <tr>
          <td id='left' class='btn'>LEFT</td>
          <td id='right' class='btn'>RIGHT</td>
        </tr>
      </table>
    </div>
  </body>
</html>