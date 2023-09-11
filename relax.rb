module Relax
  class Color
    attr_accessor :intensity

    def initialize
      @intensity = rand(0..255)
    end
  end

  class RGBAColor < Color
    attr_accessor :r, :g, :b, :a, :percentage

    COLOR_PARAMETERS = %i(r g b)

    def initialize
      @r, @g, @b = 3.times.map { Color.new }
      @a = 1
      @percentage = 10
    end
  end

  class ChangingColor < RGBAColor
    attr_accessor :directions

    def initialize
      super

      @directions = { r: :→, g: :→, b: :→ }
      @rgba_color = RGBAColor.new
    end
  end

  class Background
    attr_accessor :changing_color

    def initialize
      @changing_color = ChangingColor.new
    end

    def update_color
      RGBAColor::COLOR_PARAMETERS.each do |color_parameter|
        changing_color.directions[color_parameter] = :→ if changing_color.send(color_parameter).intensity == 0
        changing_color.directions[color_parameter] = :← if changing_color.send(color_parameter).intensity == 255

        changing_color.send(color_parameter).intensity += 1 if changing_color.directions[color_parameter] == :→
        changing_color.send(color_parameter).intensity -= 1 if changing_color.directions[color_parameter] == :←
      end

      self
    end

    def css
      rgba_color = self.changing_color

      "rgba(#{rgba_color.r.intensity}, #{rgba_color.g.intensity}, #{rgba_color.b.intensity}, #{rgba_color.a})"
    end

    def update
      `document.body.style.backgroundColor = #{self.update_color.css}`
    end
  end
end
