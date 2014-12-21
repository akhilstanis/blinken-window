=begin

  This a simple BLM player implemented using the blinken window protocol
  You can pass path to movie as an argument or if you leave it blank, script will
  download a random movie hosted at https://raw.githubusercontent.com/AndyWoodly/blinken/master/player/movies/

=end

require 'blinken_window/shifters/terminal_shifter'
require 'blinken_window/screen'

FRAME_REGEXP = /^@\d+[01\n]+/

class BlinkenMovie

  def initialize(movie_data)
    @movie_data = movie_data
  end

  def lup
    loop { play }
  end

  def play
    screen.clear
    frames.each do |frame|
      duration, frame = frame
      screen.paint(frame)
      sleep(duration/1000.0)
    end
  end

  private

  def screen
    @screen ||= BlinkenWindow::Screen.new(width, height, BlinkenWindow::Shifters::TerminalShifter.new(width, height))
  end

  def width
    @width ||= frames.first.last.first.size
  end

  def height
    @height ||= frames.first.last.size
  end

  def frames
    @frames ||= @movie_data.scan(FRAME_REGEXP).collect { |fd| parse_frame(fd) }
  end

  def parse_frame(frame_data)
    frame_rows = frame_data.split("\n")
    frame_duration = frame_rows.shift.delete('@').to_f
    [frame_duration, frame_rows.collect { |row| row.scan(/./).collect(&:to_i) }]
  end

end

# Movie collection hosted at https://github.com/AndyWoodly/blinken/tree/master/player/movies
MOVIES = ["21st_century_man.blm","3D_cube.blm","allyourbase.blm","antiwar.blm","ascii_people.blm","auge.blm","babelfish.blm","bad_luck.blm","balloon.blm","baustein.blm","be_happy.blm","biker.blm","billard.blm","binary_god.blm","bit_laden.blm","bleeeh.blm","blubb.blm","brainfuck.blm","camel.blm","chaosknoten.blm","chat_noir.blm","coffee.blm","colagoboom.blm","come_together.blm","countdown.blm","counterstrike.blm","dance.blm","dance_micky_chickee.blm","das_leben_ist_schoen.blm","defect_car.blm","die_autobahn.blm","die_erde.blm","dj.blm","dont_try_at_home.blm","encyclops.blm","falling_pix.blm","fallingpixels.blm","fallingrows.blm","fant.blm","fantasticspace.blm","femina_light.blm","fft_tim_singsang.blm","fireworks.blm","fireworks_2.blm","flipp.blm","franknstoned.blm","fussballer.blm","g.blm","game.blm","gator_rogat.blm","genomix.blm","gewaber.blm","halt.blm","hanoi.blm","herz.blm","humanistic.blm","hut.blm","illuminati.blm","impaexpa.blm","invaders_andreas.blm","invasion.blm","james_blond.blm","jesus.blm","kame.blm","kingzilla.blm","kiss.blm","klettermensch.blm","klo.blm","kreise.blm","kriechi_die_schlange.blm","labyrinth.blm","landing_zone.blm","life.blm","littlelights.intro.blm","love_berlin.blm","love_triangles.blm","luftballoons.blm","mandel.blm","manifesto1.blm","manifesto2.blm","manifesto3.blm","manifesto4.blm","manifesto5.blm","manifesto6.blm","manifesto7.blm","martelo.blm","matrix.blm","matrix_maennchen.blm","moewe_frontal.blm","moewe_nr2.blm","monster.blm","moving_car.blm","musterbeispiel.blm","om_sweet_om.blm","pacman_saga.blm","paradox.blm","peacenow.blm","peao.blm","peepshow.blm","pixie_in_the_box.blm","pixie_on_christmas.blm","planetary_assault.blm","psychowarrior.blm","pumpkin.blm","pwm.blm","quantorenlyrik.blm","quix_glitter.blm","railroad.blm","rain.blm","raindrops.blm","rakete.blm","raumschiff_enterprise.blm","relativity.blm","rollo_grow.blm","sanduhr.blm","schnecke.blm","scooter.blm","shootsscore.blm","silent_night.blm","sinus.blm","snake.blm","sortofselftest.blm","speedit.blm","spin.blm","spirals.blm","sport_haelt_fit.blm","supermaennchen.blm","surprise.blm","tetris.blm","the_fly.blm","thomas.blm","thunderstorm.blm","timeless.blm","tla_nerd1.blm","tla_nerd2.blm","tla_nerd3.blm","tla_nerd4.blm","tla_nerd5.blm","tla_nerd6.blm","tla_nerd7.blm","tla_nerd8.blm","tla_them.blm","torus.blm","tropfen.blm","tux.blm","variationen.blm","vlhurg.blm","vomit.blm","warterad.blm","wasserhahn.blm","wein_trinken.blm","windshield.blm","winslows.blm","winter_in_the_city.blm","worm.blm","x-ball.blm","xxccc.blm","yeastman.blm","yin_yang.blm","zeichen.blm"]

movie_data = if ARGV[0]
  File.read(ARGV[0])
else
  require 'open-uri'
  movie = MOVIES.shuffle.first
  puts "Downloading #{movie}..."
  open("https://raw.githubusercontent.com/AndyWoodly/blinken/master/player/movies/#{movie}").read
end

BlinkenMovie.new(movie_data).lup
