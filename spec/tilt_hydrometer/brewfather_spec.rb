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
  end
end
