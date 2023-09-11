module Relax
  class Color
    attr_accessor :intensity

    def initialize
      self.intensity = rand(0..100)
    end
  end

  class RGBAColor
    attr_accessor :r, :g, :b, :a, :percentage

    COLOR_PARAMETERS = %i(r g b)

    def initialize
      COLOR_PARAMETERS.each { |p| self.send("#{p}=", Color.new) }
      self.a = 1
      self.percentage = 10
    end
  end

  class ChangingColor
    attr_accessor :rgba_color, :direction

    def initialize
      Color.instance_eval do
        attr_accessor :direction
      end

      self.rgba_color = RGBAColor.new

      RGBAColor::COLOR_PARAMETERS.each do |color_parameter|
        self.rgba_color.send(color_parameter).direction = :→
      end
    end
  end

  class Background
    attr_accessor :color

    def initialize
      self.color = ChangingColor.new
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
