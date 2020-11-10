# frozen_string_literal: true

require 'logger'

require 'scan_beacon'
require 'faraday'

class TiltHydrometer
  DEVICES = {
    'A495BB10C5B14B44B5121370F02D74DE' => 'Red',
    'A495BB20C5B14B44B5121370F02D74DE' => 'Green',
    'A495BB30C5B14B44B5121370F02D74DE' => 'Black',
    'A495BB40C5B14B44B5121370F02D74DE' => 'Purple',
    'A495BB50C5B14B44B5121370F02D74DE' => 'Orange',
    'A495BB60C5B14B44B5121370F02D74DE' => 'Blue',
    'A495BB70C5B14B44B5121370F02D74DE' => 'Yellow',
    'A495BB80C5B14B44B5121370F02D74DE' => 'Pink'
  }.freeze

  def initialize(url)
    @url = url
    @logger = Logger.new($stdout)
    @scanner = ScanBeacon::DefaultScanner.new
    @scanner.add_parser(
      ScanBeacon::BeaconParser.new(
        :tilt,
        'm:0-5=4c000215a495,i:4-19,d:20-21,d:22-23,p:24-25'
      )
    )
  end

  def run
    @scanner.scan do |beacons|
      beacons.each do |beacon|
        process_beacon(beacon)
      end
    end
  end

  private

  def process_beacon(beacon)
    @logger.info("Beacon: #{beacon.inspect}")
    @logger.info("Data: #{beacon.data.inspect}")

    post(
      color(beacon),
      temp(beacon),
      gravity(beacon)
    )
  end

  def post(color, temp, gravity)
    Faraday.post(
      @url,
      "{\"name\": \"Tilt #{color}\", \"temp\": \"#{temp}\", \"temp_unit\": \"F\", \"gravity\": #{gravity}, \"gravity_unit\": \"G\"}",
      'Content-Type' => 'application/json'
    )
  end

  def color(beacon)
    DEVICES[beacon.ids[0].to_s.upcase]
  end

  def temp(beacon)
    beacon.data[0]
  end

  def gravity(beacon)
    gravity_string = beacon.data[1].to_s

    "#{gravity_string[-4] || 0}.#{gravity_string[-3..-1]}"
  end
end
