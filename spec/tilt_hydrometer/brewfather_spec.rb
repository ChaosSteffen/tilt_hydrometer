# frozen_string_literal: true

require 'spec_helper'

describe TiltHydrometer::Brewfather do
  subject(:brewfather) { described_class.new(url, interval) }

  let(:url) { 'https://brewfather.example' }
  let(:interval) { 60 }

  let(:beacon) do
    instance_double(
      TiltHydrometer::Beacon,
      uuid: 'A495BB10C5B14B44B5121370F02D74DE',
      temp: 60,
      gravity: 1234,
      color: 'Red'
    )
  end

  describe '#post' do
    before do
      stub_request(:post, url)

      brewfather.post(beacon)
    end

    it 'posts the beacon to Brewfather' do
      expect(WebMock).to have_requested(:post, url)
        .with(
          body: '{"name":"Tilt-Red","temp":"60","temp_unit":"F","gravity":"1234","gravity_unit":"G"}',
          headers: { 'Content-Type' => 'application/json' }
        ).once
    end

    describe 'throttling' do
      let(:another_beacon) do
        instance_double(
          TiltHydrometer::Beacon,
          uuid: 'A495BB30C5B14B44B5121370F02D74DE',
          temp: 50,
          gravity: 1123,
          color: 'Black'
        )
      end

      before do
        allow(TiltHydrometer::LOGGER).to receive(:debug)
      end

      it 'does not post the beacon to Brewfather twice' do
        2.times { brewfather.post(beacon) }

        expect(WebMock).to have_requested(:post, url).once
      end

      it 'does post the beacon to Brewfather after the interval' do
        brewfather.post(beacon)

        Timecop.travel(Time.now + interval + 1) do
          brewfather.post(beacon)

          expect(WebMock).to have_requested(:post, url).twice
        end
      end

      it 'does post two different beacons to Brewfather' do
        brewfather.post(beacon)
        brewfather.post(another_beacon)

        expect(WebMock).to have_requested(:post, url).twice
      end
    end
  end
end
