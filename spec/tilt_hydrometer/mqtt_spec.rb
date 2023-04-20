# frozen_string_literal: true

require 'spec_helper'

describe TiltHydrometer::MQTT do
  subject(:brewfather) { described_class.new(mqtt_uri, prefix) }

  let(:mqtt_uri) { 'mqtt://mqtt.example' }
  let(:prefix) { 'tilt/' }

  let(:client) { instance_double(MQTT::Client) }

  describe '#publish' do
    let(:beacon) { TiltHydrometer::Beacon.new('A495BB10C5B14B44B5121370F02D74DE', 60, 1234) }

    before do
      allow(MQTT::Client).to receive(:connect).and_yield(client)
      allow(client).to receive(:publish)

      brewfather.publish(beacon)
    end

    it 'publishes full data as JSON' do
      expect(client).to have_received(:publish).with(
        'tilt/Red', '{"temp_f":60,"temp_c":15.6,"gravity_sg":1.234,"gravity_p":50.1}'
      )
    end

    it 'publishes temperature in Fahrenheit' do
      expect(client).to have_received(:publish).with('tilt/Red/temp_f', 60)
    end

    it 'publishes temperature in Celsius' do
      expect(client).to have_received(:publish).with('tilt/Red/temp_c', 15.6)
    end

    it 'publishes gravity in specific gravity' do
      expect(client).to have_received(:publish).with('tilt/Red/gravity_sg', 1.234)
    end

    it 'publishes gravity in plato' do
      expect(client).to have_received(:publish).with('tilt/Red/gravity_p', 50.1)
    end
  end
end
