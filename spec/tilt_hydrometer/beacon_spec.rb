# frozen_string_literal: true

require 'spec_helper'

describe TiltHydrometer::Beacon do
  subject(:beacon) { described_class.new(uuid, temp, gravity) }

  let(:uuid) { 'A495BB10C5B14B44B5121370F02D74DE' }
  let(:temp) { 60 } # Fahrenheit
  let(:gravity) { 1234 }

  describe '#color' do
    it 'return the color' do
      expect(beacon.color).to eq 'Red'
    end
  end

  describe '#temp' do
    it 'returns the temperature' do
      expect(beacon.temp).to eq 60
    end

    describe 'when the device is a Tilt Pro' do
      let(:gravity) { 11_010 }

      it 'returns the temperature more accurate' do
        expect(beacon.temp).to eq 6.0
      end
    end
  end

  describe '#gravity' do
    it 'returns the gravity' do
      expect(beacon.gravity).to eq 1.234
    end

    describe 'when the device is a Tilt Pro' do
      let(:gravity) { 12_345 }

      it 'returns the gravity more accurate' do
        expect(beacon.gravity).to eq 1.2345
      end
    end
  end

  describe '#plato' do
    let(:gravity) { 1050 }

    it 'converts gravity to plato' do
      expect(beacon.plato).to eq 12.4
    end
  end

  describe '#celsius' do
    it 'converts temperature to celsius' do
      expect(beacon.celsius).to eq 15.6
    end
  end

  describe '#values_out_of_range?' do
    context 'when the temperature is out of range' do
      let(:temp) { 213 }

      it 'returns true' do
        expect(beacon.values_out_of_range?).to be true
      end
    end

    context 'when the temperature is in range' do
      it 'returns false' do
        expect(beacon.values_out_of_range?).to be false
      end
    end
  end

  describe '#log' do
    before do
      allow(TiltHydrometer::LOGGER).to receive(:debug)

      beacon.log
    end

    it 'logs the beacon' do
      expect(TiltHydrometer::LOGGER).to have_received(:debug).with("Beacon: #{beacon.inspect}")
    end

    it 'logs the temperature' do
      expect(TiltHydrometer::LOGGER).to have_received(:debug).with('Temp: 60')
      expect(TiltHydrometer::LOGGER).to have_received(:debug).with('Celsius: 15.6')
    end

    it 'logs the gravity' do
      expect(TiltHydrometer::LOGGER).to have_received(:debug).with('Gravity: 1.234')
    end

    it 'logs the color' do
      expect(TiltHydrometer::LOGGER).to have_received(:debug).with('Color: Red')
    end

    it 'logs the UUID' do
      expect(TiltHydrometer::LOGGER).to have_received(:debug).with('UUID: A495BB10C5B14B44B5121370F02D74DE')
    end
  end

  describe '#pro?' do
    context 'when the device is a Tilt Pro' do
      let(:gravity) { 11_010 }

      it 'returns true' do
        expect(beacon.pro?).to be true
      end
    end

    context 'when the device is not a Tilt Pro' do
      it 'returns false' do
        expect(beacon.pro?).to be false
      end
    end
  end

  # add failing spec
  it 'fails' do
    expect(true).to be false
  end
end
