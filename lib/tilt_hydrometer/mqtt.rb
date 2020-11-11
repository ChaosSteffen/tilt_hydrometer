# frozen_string_literal: true

module TiltHydrometer
  class MQTT
    def initialize(mqtt_uri, prefix)
      @mqtt_uri = mqtt_uri
      @prefix = prefix
    end

    def publish(beacon)
      ::MQTT::Client.connect(@mqtt_uri) do |c|
        c.publish(topic(beacon), beacon_json(beacon), true)
      end
    end

    private

    def topic(beacon)
      @prefix + beacon.color
    end

    def beacon_json(beacon)
      JSON.generate(
        temp_f: beacon.temp,
        temp_c: beacon.celsius,
        gravity_sg: beacon.gravity,
        gravity_p: beacon.plato
      )
    end
  end
end
