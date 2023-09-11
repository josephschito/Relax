module Relax
  class Color
    attr_accessor :intensity

    def initialize
      @intensity = rand(0..255)
    end
  end

  class RGBAColor
    attr_accessor :r, :g, :b, :a, :percentage

    COLOR_PARAMETERS = %i(r g b)

    def initialize
      @r, @g, @b = 3.times.map { Color.new }
      @a = 1
      @percentage = 10
    end
  end

  class ChangingColor
    attr_accessor :rgba_color, :direction

    def initialize
      Color.instance_eval do
        attr_accessor :direction
      end

      @rgba_color = RGBAColor.new

      RGBAColor::COLOR_PARAMETERS.each do |color_parameter|
        @rgba_color.send(color_parameter).direction = :→
      end
    end
  end

  class Background
    attr_accessor :color

    def initialize
      @color = ChangingColor.new
    end

    def update_color
      RGBAColor::COLOR_PARAMETERS.each do |color_parameter|
        color = self.color.rgba_color.send(color_parameter)

        color.direction = :→ if color.intensity == 0
        color.direction = :← if color.intensity == 255

        color.intensity += 1 if color.direction == :→
        color.intensity -= 1 if color.direction == :←
      end

      self
    end

    def css
      rgba_color = self.color.rgba_color

      "rgba(#{rgba_color.r.intensity}, #{rgba_color.g.intensity}, #{rgba_color.b.intensity}, #{rgba_color.a})"
    end

    def update
      `document.body.style.backgroundColor = #{self.update_color.css}`
    end
  end
end
