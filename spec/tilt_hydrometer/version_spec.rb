# frozen_string_literal: true

require 'spec_helper'

describe TiltHydrometer::VERSION do
  it 'has a version number' do
    # rubocop:disable RSpec/DescribedClass
    expect(TiltHydrometer::VERSION).not_to be_nil
    # rubocop:enable RSpec/DescribedClass
  end
end
