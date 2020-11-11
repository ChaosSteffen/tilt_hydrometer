# frozen_string_literal: true

module TiltHydrometer
  class Brewfather
    include TiltHydrometer::ThrotteledExecution

    def initialize(url, interval)
      @url = url
      @interval = interval
    end

    def post(beacon)
      throtteled_execution(beacon.uuid) do
        Faraday.post(@url, beacon_json(beacon), 'Content-Type' => 'application/json')
      end
    end

    private

    def beacon_json(beacon)
      {
        name: "Tilt-#{beacon.color}",
        temp: beacon.temp.to_s,
        temp_unit: 'F',
        gravity: beacon.gravity.to_s,
        gravity_unit: 'G'
      }.to_json
    end
  end
end
