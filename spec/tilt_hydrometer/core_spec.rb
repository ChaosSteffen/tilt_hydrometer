# frozen_string_literal: true

require 'spec_helper'

describe TiltHydrometer::Core do
  subject(:core) { described_class.new(options) }

  let(:options) { {} }

  describe '#run' do
    let(:stdout) do
      StringIO.new(
        <<~BEACON
          > 04 3E 2A 02 01 03 01 E5 4D AA 4B 87 F6 1E 02 01 04 1A FF 4C
            00 02 15 A4 95 BB 30 C5 B1 4B 44 B5 12 13 70 F0 2D 74 DE 00
            1E 03 F6 68 AC
          >
        BEACON
      )
    end

    before do
      allow(Open3).to receive(:popen3).and_yield(nil, stdout, nil, nil)
      allow(TiltHydrometer::LOGGER).to receive(:debug)
    end

    it 'logs the UUID of a beacon' do
      core.run

      expect(TiltHydrometer::LOGGER).to have_received(:debug).with('UUID: A495BB30C5B14B44B5121370F02D74DE')
    end

    it 'logs the temperature of a beacon' do
      core.run

      expect(TiltHydrometer::LOGGER).to have_received(:debug).with('Temp: 30')
      expect(TiltHydrometer::LOGGER).to have_received(:debug).with('Celsius: -1.1')
    end

    it 'logs the gravity of a beacon' do
      core.run

      expect(TiltHydrometer::LOGGER).to have_received(:debug).with('Gravity: 1.014')
      expect(TiltHydrometer::LOGGER).to have_received(:debug).with('Color: Black')
    end

    describe 'when the temperature is out of range' do
      before do
        # TODO: Rather change the beacon text (hex) to test this
        # rubocop:disable RSpec/AnyInstance
        allow_any_instance_of(TiltHydrometer::Beacon).to receive(:values_out_of_range?).and_return(true)
        # rubocop:enable RSpec/AnyInstance
      end

      it 'logs that the values are out of range' do
        core.run

        expect(TiltHydrometer::LOGGER).to have_received(:debug).with('values out of range')
      end
    end

    describe 'when brewfather is configured' do
      let(:options) { { brewfather: 'http://brewfather.exmple', interval: 60 } }
      let(:brewfather) { instance_double(TiltHydrometer::Brewfather, post: nil) }

      before do
        allow(TiltHydrometer::Brewfather).to receive(:new).and_return(brewfather)
      end

      it 'posts to brewfather' do
        core.run

        expect(brewfather).to have_received(:post).with(kind_of(TiltHydrometer::Beacon))
      end
    end

    # same for mqtt
    describe 'when mqtt is configured' do
      let(:options) { { mqtt: 'mqtt://mqtt.example', mqtt_prefix: 'tilt' } }
      let(:mqtt) { instance_double(TiltHydrometer::MQTT, publish: nil) }

      before do
        allow(TiltHydrometer::MQTT).to receive(:new).and_return(mqtt)
      end

      it 'posts to mqtt' do
        core.run

        expect(mqtt).to have_received(:publish).with(kind_of(TiltHydrometer::Beacon))
      end
    end
  end
end
