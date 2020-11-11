# frozen_string_literal: true

module TiltHydrometer
  module BeaconDecorator
    def color
      TiltHydrometer::DEVICES[uuid]
    end

    def temp
      data[0].to_i
    end

    def gravity
      gravity_string = data[1].to_s

      "#{gravity_string[-4] || 0}.#{gravity_string[-3..-1]}".to_f
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
      temp > 212
    end

    def log
      LOGGER.debug("Beacon: #{inspect}")
      LOGGER.debug("Data: #{data.inspect}")
      LOGGER.debug("UUID: #{uuid.inspect}")
    end
  end
end
