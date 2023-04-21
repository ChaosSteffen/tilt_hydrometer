# frozen_string_literal: true

require 'open3'

module TiltHydrometer
  class Core
    def initialize(options = {})
      @options = options
    end

    def run
      Open3.popen3 'hcidump -R' do |_stdin, stdout, _stderr, _thread|
        buffer = []
        while (line = stdout.gets)
          if line.start_with?('>', '<')
            process_advertisement(buffer.join.gsub(/\s+/, ''))

            buffer = []
          end

          buffer << line[2..-2]
        end
      end
    end

    private

    def process_advertisement(data)
      return unless (match = data.match(/\h{40}(A495BB[1-8]0C5B14B44B5121370F02D74DE)(\h{4})(\h{4})(\h{2})(\h{2})/i))

      uuid, temp, gravity, _power, _rssi = match.captures

      beacon = Beacon.new(uuid, temp.to_i(16), gravity.to_i(16))
      beacon.log

      if beacon.values_out_of_range?
        LOGGER.debug('values out of range')
      else
        brewfather&.post(beacon)
        mqtt&.publish(beacon)
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
