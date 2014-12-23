require 'wiringpi'

module BlinkenWindow::Shifters

  class GPIOShifter
    attr_reader :clock_pin, :data_pin, :strobe_pin

    def initialize(clock_pin, data_pin, strobe_pin)
      @clock_pin  = clock_pin
      @data_pin   = data_pin
      @strobe_pin = strobe_pin

      io.mode(clock_pin,  OUTPUT)
      io.mode(data_pin,   OUTPUT)
      io.mode(strobe_pin, OUTPUT)
    end

    def push(matrix)
      serialize(matrix).each do |bit|
        io.write(data_pin, bit)
        tick
      end

      strobe
    end

    private

    def io
      @io ||= WiringPi::GPIO.new
    end

    def pulse(pin)
      io.write(pin, 0)
      io.write(pin, 1)
      io.write(pin, 0)
    end

    def strobe
      pulse(strobe_pin)
    end

    def tick
      pulse(clock_pin)
    end

    def serialize(matrix)
      matrix.transpose.reverse.collect(&:reverse).flatten
    end
  end

end