# frozen_string_literal: true

require 'spec_helper'

describe TiltHydrometer::DEVICES do
  it 'has a list of devices' do
    # rubocop:disable RSpec/DescribedClass
    expect(TiltHydrometer::DEVICES).to be_a Hash
    # rubocop:enable RSpec/DescribedClass
  end
end
