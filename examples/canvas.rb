
require 'blinken_window/shifters/terminal_shifter'
require 'blinken_window/screen'

require 'sinatra'
require 'sinatra-websocket'

set :server, 'thin'
set :bind, '0.0.0.0'
set :sockets, []
set :logging, false # Terminal emulator works best when logging if off

class ScreenManager
  def initialize
    @screen = BlinkenWindow::Screen.new(6,10, BlinkenWindow::Shifters::TerminalShifter.new(6,10))
    @screen.clear
  end

  def process(msg)
    case msg
    when /clear/
      @screen.clear
    when /\d,\d,\d/
      @screen.put(*msg.split(',').collect(&:to_i))
    end
  end
end


get '/' do
  @sm = ScreenManager.new
  if !request.websocket?
    erb :index
  else
    request.websocket do |ws|
      ws.onopen do
        settings.sockets << ws
      end

      ws.onmessage do |msg|
        @sm.process(msg)
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
    <style>
      .window { width: 700px; }
      .controls { width: 200px; display: inline; }
      .controls button { font-size: 22px; padding: 10px; }
      .box {
        float: left;
        width:  103px;
        height: 103px;
        border: #000 1px solid;
        margin: 5px;
      }
      .on { background: #ccc; }
    </style>
    <script src="http://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>
    <script>
      $(function(){
        var ws = new WebSocket('ws://' + window.location.host + window.location.pathname);

        var toggleBulb = function(){
          $(this).toggleClass('on');
          ws.send($(this).attr('id').split('x').join(',') + ',' + ($(this).hasClass('on') ? 1 : 0) )
        };

        var clearScreen = function(){
          $('.on').removeClass('on');
          ws.send('clear');
        };

        $('.box').on('click', toggleBulb);
        $('.clear').on('click', clearScreen);

        // Tablets better use touchstart for more responsive experience
        // $('.box').on('touchstart', toggleBulb);
        // $('.clear').on('touchstart', clearScreen);
      });
    </script>
  </head>
  <body>
    <div class="window">
      <div id='0x0' class='box'></div>
      <div id='1x0' class='box'></div>
      <div id='2x0' class='box'></div>
      <div id='3x0' class='box'></div>
      <div id='4x0' class='box'></div>
      <div id='5x0' class='box'></div>
      <div id='0x1' class='box'></div>
      <div id='1x1' class='box'></div>
      <div id='2x1' class='box'></div>
      <div id='3x1' class='box'></div>
      <div id='4x1' class='box'></div>
      <div id='5x1' class='box'></div>
      <div id='0x2' class='box'></div>
      <div id='1x2' class='box'></div>
      <div id='2x2' class='box'></div>
      <div id='3x2' class='box'></div>
      <div id='4x2' class='box'></div>
      <div id='5x2' class='box'></div>
      <div id='0x3' class='box'></div>
      <div id='1x3' class='box'></div>
      <div id='2x3' class='box'></div>
      <div id='3x3' class='box'></div>
      <div id='4x3' class='box'></div>
      <div id='5x3' class='box'></div>
      <div id='0x4' class='box'></div>
      <div id='1x4' class='box'></div>
      <div id='2x4' class='box'></div>
      <div id='3x4' class='box'></div>
      <div id='4x4' class='box'></div>
      <div id='5x4' class='box'></div>
      <div id='0x5' class='box'></div>
      <div id='1x5' class='box'></div>
      <div id='2x5' class='box'></div>
      <div id='3x5' class='box'></div>
      <div id='4x5' class='box'></div>
      <div id='5x5' class='box'></div>
      <div id='0x6' class='box'></div>
      <div id='1x6' class='box'></div>
      <div id='2x6' class='box'></div>
      <div id='3x6' class='box'></div>
      <div id='4x6' class='box'></div>
      <div id='5x6' class='box'></div>
      <div id='0x7' class='box'></div>
      <div id='1x7' class='box'></div>
      <div id='2x7' class='box'></div>
      <div id='3x7' class='box'></div>
      <div id='4x7' class='box'></div>
      <div id='5x7' class='box'></div>
      <div id='0x8' class='box'></div>
      <div id='1x8' class='box'></div>
      <div id='2x8' class='box'></div>
      <div id='3x8' class='box'></div>
      <div id='4x8' class='box'></div>
      <div id='5x8' class='box'></div>
      <div id='0x9' class='box'></div>
      <div id='1x9' class='box'></div>
      <div id='2x9' class='box'></div>
      <div id='3x9' class='box'></div>
      <div id='4x9' class='box'></div>
      <div id='5x9' class='box'></div>
    </div>
    <div class="controls">
      <button class="clear">Clear</button>
    </div>
  </body>
</html>