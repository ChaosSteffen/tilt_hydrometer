# frozen_string_literal: true

module TiltHydrometer
  class Core
    def initialize(options = {})
      @options = options
    end

    def run
      scanner.scan do |beacons|
        beacons.each do |beacon|
          beacon.extend(TiltHydrometer::BeaconDecorator)
          beacon.log

          if beacon.values_out_of_range?
            LOGGER.debug('values out of range') && next
          end

          brewfather&.post(beacon)
          mqtt&.publish(beacon)
        end
      end
    end

    private

    def scanner
      @scanner ||=
        ScanBeacon::DefaultScanner.new.tap do |s|
          s.add_parser(
            ScanBeacon::BeaconParser.new(
              :tilt, 'm:0-5=4c000215a495,i:4-19,d:20-21,d:22-23,p:24-25'
            )
          )
        end
    end

    def brewfather
      return unless @options[:brewfather] && @options[:interval]

      @brewfather ||=
        TiltHydrometer::Brewfather.new(@options[:brewfather], @options[:interval])
    end

    def mqtt
      return unless @options[:mqtt] && @options[:mqtt_prefix]

      @mqtt ||=
        TiltHydrometer::MQTT.new(@options[:mqtt], @options[:mqtt_prefix])
    end
  end
end
