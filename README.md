# BlinkenWindow

A simple ruby library to control the blinken lights setup on my front window. :)

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

    screen = BlinkenWindow::Screen.new(6,10, BlinkenWindow::Shifters::TerminalShifter.new(6,10))

## Examples

Also checkout the examples folder to start playing around

  * canvas.rb -  A web interface to control the bulbs.
  * blm_player.rb - A simple blm palyer which can play blinken movies

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
