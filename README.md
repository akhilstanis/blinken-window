# BlinkenWindow

A simple ruby library to control the blinken lights setup on my front window. :)

<a href='https://www.youtube.com/watch?v=FQo2XVC0iSQ' target='_blank'><img src='https://cloud.githubusercontent.com/assets/955760/5564442/261ab332-8ee7-11e4-8480-2f0c218a6655.png' height='250' /></a>
<a href='https://asciinema.org/a/14974?autoplay=1' target='_blank'><img src='https://cloud.githubusercontent.com/assets/955760/5542335/07769048-8b0b-11e4-9f44-b34fe9a41c8b.png' height='250' /></a>

Video of the actual window and simulator running the demo.

## Installation

Add this line to your application's Gemfile:

    gem 'blinken_window', :github => 'akhilstanislavose/blinken-window'

And then execute:

    $ bundle

## Usage

To get started you can use a simulator which runs on the terminal.

    require 'blinken_window/shifters/terminal_shifter'
    require 'blinken_window/screen'

    # Setup a screen with 6 columns and 10 rows
    screen = BlinkenWindow::Screen.new(6,10, BlinkenWindow::Shifters::TerminalShifter.new(6,10))

    # clears the screen
    screen.clear

    # Lights up the bulb at (x,y)
    screen.put(0,0)

    # Resets up the bulb at (x,y)
    screen.put(0,0,0)

    # Sets the pixel but doesnt render it, so call render explicitly to render
    screen.set(5,9)
    screen.render

    # Paints the entire screen with matrix given
    screen.paint(matix)

Once you have the animation/game/wierd idea ready and need to test it on the actual thing, just change the shifter to an object of `BlinkenWindow::Shifters::GPIOShifter`

    screen = BlinkenWindow::Screen.new(6,10, BlinkenWindow::Shifters::GPIOShifter.new(6,10))

**NB: `BlinkenWindow::Shifters::GPIOShifter` requires `wiringpi` gem, and you will need Raspberry Pi to run it.**

## Examples

Also checkout the examples folder to start playing around

  * [canvas.rb](https://github.com/akhilstanislavose/blinken-window/blob/master/examples/canvas.rb) -  A web interface to control the bulbs.
  * [blm_player.rb](https://github.com/akhilstanislavose/blinken-window/blob/master/examples/blm_player.rb) - A simple blm palyer which can play blinken movies
  * [pong.rb](https://github.com/akhilstanislavose/blinken-window/blob/master/examples/pong.rb) - Class pong game that can be controlled using keyboard or websocked client
  * [blinken_string.rb](https://github.com/akhilstanislavose/blinken-window/blob/master/examples/blinken_string.rb) - A string class which can easily generate frames to animate text on blinken window
  * [matrix.rb](https://github.com/akhilstanislavose/blinken-window/blob/master/examples/matrix.rb) - Using matrices to generate frames with patterns really fast

By default all the example are set to use terminal emulator so that you can see the output. Some example use web interface to control them so open up the browser.

    # Examples might need some extra gems to work, eg., sinatra
    bundle install

    bundle exec ruby examples/blinken_string.rb

**NB: Terminal emulator is implemented using curses library, which used to be part of Ruby standard library till 2.0, so you will have to run the examples using version not greater than 2.0**

## Hardware
The requirement was to connect 60 leds to Raspberry Pi, but it doesn't have that many GPIO pins. So the solution was to use an output exapnder, which could provide 60 outputs. Easisest way to do that is to use Shift Registers with latch option, they act as a serial to parallel converter. We can stream the serial data in to the shift register and it will set its outputs corresponding to the bits received. Standard shift registers(CD4094, 74HC595) are 8bits ie., 8 outputs, but by cascading 8 of them we can have 64 outputs. Below is a snap a of expander board I built.

<a href='https://cloud.githubusercontent.com/assets/955760/5890923/e5f48db8-a49a-11e4-929b-4f0f48dff38e.JPG' target='_blank'><img src='https://cloud.githubusercontent.com/assets/955760/5890923/e5f48db8-a49a-11e4-929b-4f0f48dff38e.JPG' width='100%' /></a>

Along with the shift register I also had to use transitors to drive the LEDs as the shift registers couldn't provide enough current to drive the 50mA LEDs I used. To make the project extensible, I have designed a simple module which can be connected like legos and you can extend the number of outputs as per your requirment.

<a href='https://cloud.githubusercontent.com/assets/955760/5890875/8682e50c-a498-11e4-9b8c-3297258aa1be.png' target='_blank'><img src='https://cloud.githubusercontent.com/assets/955760/5890875/8682e50c-a498-11e4-9b8c-3297258aa1be.png' height='300' /></a>
<a href='https://cloud.githubusercontent.com/assets/955760/5890874/867b4edc-a498-11e4-9a2b-b43e0995720c.png' target='_blank'><img src='https://cloud.githubusercontent.com/assets/955760/5890874/867b4edc-a498-11e4-9a2b-b43e0995720c.png' height='300' /></a>

The module idea came late to me as my friends asked me the easiest way to make thier windows blink without all the soldering and stuff. I am in the process of fabricating the actual PCBs and once it is done, I will put some pictures of it. You can download the Eagle files from [http://goo.gl/GG7Nz7](http://goo.gl/GG7Nz7)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
