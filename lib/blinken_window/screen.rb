module BlinkenWindow

  class Screen
    attr_reader :maxx, :maxy, :shifter

    def initialize(maxx, maxy, shifter)
      @maxx = maxx
      @maxy = maxy
      @shifter = shifter
    end

    def set(x, y, color=1)
      raise ArgumentError.new("Invalid x = #{x} | x cannot be >= maxx or < 0 ie., #{maxx}") unless (0...maxx).include?(x)
      raise ArgumentError.new("Invalid y = #{y} | y cannot be >= maxy or < 0 ie., #{maxy}") unless (0...maxy).include?(y)

      view[y][x] = color
    end

    def put(x, y, color=1)
      set(x, y, color)
      render
    end

    def paint(matrix)
      @view = matrix
      render
    end

    def clear
      @view = zeroes
      render
    end

    def render
      shifter.push(view)
    end

    private

    def view
      @view ||= zeroes
    end

    def zeroes
      ('0' * (maxx*maxy)).scan(/0{#{maxx}}/).collect { |x| x.scan(/./).collect(&:to_i) }
    end
  end

end