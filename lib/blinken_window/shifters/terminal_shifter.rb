require 'curses'

module BlinkenWindow::Shifters

  class TerminalShifter
    include Curses

    attr_reader :maxx, :maxy, :width, :height

    def initialize(maxx, maxy, width=8, height=4)
      @maxx, @maxy, @width, @height = maxx, maxy, width, height
      init_screen
      nonl
      cbreak
      noecho
    end

    def push(matrix)
      matrix.size.times do |row|
        matrix[row].size.times do |col|
          window = windows[row][col]
          window.bkgd(matrix[row][col] == 1 ? '@' : ' ')
          window.refresh
        end
      end
    end

    def windows
      @windows ||= (0...maxy).to_a.collect do |row|
        (0...maxx).to_a.collect do |col|
          window = Curses::Window.new(height, width , row * height , col * (width + 1))
          window.box(?|, ?-)
          window
        end
      end
    end
  end

end