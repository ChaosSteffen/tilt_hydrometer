# frozen_string_literal: true

module TiltHydrometer
  module BeaconDecorator
    def color
      TiltHydrometer::DEVICES[uuid]
    end

    def temp
      data[0].to_s
    end

    def gravity
      gravity_string = data[1].to_s

      "#{gravity_string[-4] || 0}.#{gravity_string[-3..-1]}"
    end

    def log
      LOGGER.debug("Beacon: #{inspect}")
      LOGGER.debug("Data: #{data.inspect}")
      LOGGER.debug("UUID: #{uuid.inspect}")
    end
  end
end
