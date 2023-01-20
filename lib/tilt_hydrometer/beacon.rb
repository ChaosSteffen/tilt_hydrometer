# frozen_string_literal: true

module TiltHydrometer
  class Beacon
    def initialize(uuid, temp, gravity)
      @uuid = uuid
      @temp = temp
      @gravity = gravity
    end

    def uuid
      @uuid
    end

    def color
      TiltHydrometer::DEVICES[@uuid]
    end

    def temp
      if pro?
        @temp.to_i/10.0
      else
        @temp.to_i
      end
    end

    def gravity
      gravity_string = @gravity.to_s

      if pro?
        "#{gravity_string[-5] || 0}.#{gravity_string[-4..-1]}".to_f
      else
        "#{gravity_string[-4] || 0}.#{gravity_string[-3..-1]}".to_f
      end
    end

    def plato
      (
        (-1 * 616.868) +
        (1111.14 * gravity) -
        (630.272 * (gravity**2)) +
        (135.997 * (gravity**3))
      ).round(1)
    end

    def celsius
      (
        (temp - 32.0) * (5.0 / 9.0)
      ).round(1)
    end

    def values_out_of_range?
      temp > 212 || temp < 1
    end

    def log
      LOGGER.debug("Beacon: #{inspect}")
      LOGGER.debug("Temp: #{temp}")
      LOGGER.debug("Celsius: #{celsius}")
      LOGGER.debug("Gravity: #{gravity}")
      LOGGER.debug("Color: #{color}")
      LOGGER.debug("UUID: #{@uuid}")
    end

    def pro?
      @gravity.to_s[-5] == '1'
    end
  end
end
