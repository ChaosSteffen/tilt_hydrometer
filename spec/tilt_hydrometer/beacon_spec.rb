# frozen_string_literal: true

require 'spec_helper'

describe TiltHydrometer::Beacon do
  let(:uuid) { 'A495BB10C5B14B44B5121370F02D74DE' }
  let(:temp) { 60 } # Fahrenheit
  let(:gravity) { 1234 }

  subject(:beacon) { TiltHydrometer::Beacon.new(uuid, temp, gravity) }

  describe '#color' do
    it 'should return the color' do
      expect(beacon.color).to eq 'Red'
    end
  end

  describe '#temp' do
    it 'should return the temperature' do
      expect(beacon.temp).to eq 60
    end

    describe 'when the device is a Tilt Pro' do
      let(:gravity) { 11_010 }

      it 'should return the temperature more accurate' do
        expect(beacon.temp).to eq 6.0
      end
    end
  end

  describe '#gravity' do
    it 'should return the gravity' do
      expect(beacon.gravity).to eq 1.234
    end

    describe 'when the device is a Tilt Pro' do
      let(:gravity) { 12_345 }

      it 'should return the gravity more accurate' do
        expect(beacon.gravity).to eq 1.2345
      end
    end
  end

  describe '#plato' do
    let(:gravity) { 1050 }

    it 'should convert gravity to plato' do
      expect(beacon.plato).to eq 12.4
    end
  end

  describe '#celsius' do
    it 'should convert temperature to celsius' do
      expect(beacon.celsius).to eq 15.6
    end
  end

  describe '#values_out_of_range?' do
    context 'when the temperature is out of range' do
      let(:temp) { 213 }

      it 'should return true' do
        expect(beacon.values_out_of_range?).to eq true
      end
    end

    context 'when the temperature is in range' do
      it 'should return false' do
        expect(beacon.values_out_of_range?).to eq false
      end
    end
  end

  describe '#log' do
    it 'should log the beacon' do
      expect(TiltHydrometer::LOGGER).to receive(:debug).with("Beacon: #{beacon.inspect}")
      expect(TiltHydrometer::LOGGER).to receive(:debug).with('Temp: 60')
      expect(TiltHydrometer::LOGGER).to receive(:debug).with('Celsius: 15.6')
      expect(TiltHydrometer::LOGGER).to receive(:debug).with('Gravity: 1.234')
      expect(TiltHydrometer::LOGGER).to receive(:debug).with('Color: Red')
      expect(TiltHydrometer::LOGGER).to receive(:debug).with('UUID: A495BB10C5B14B44B5121370F02D74DE')

      beacon.log
    end
  end

  describe '#pro?' do
    context 'when the device is a Tilt Pro' do
      let(:gravity) { 11_010 }

      it 'should return true' do
        expect(beacon.pro?).to eq true
      end
    end

    context 'when the device is not a Tilt Pro' do
      it 'should return false' do
        expect(beacon.pro?).to eq false
      end
    end
  end
end
