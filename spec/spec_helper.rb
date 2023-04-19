# frozen_string_literal: true

require 'simplecov'
SimpleCov.start do
  track_files 'lib/**/*.rb'
end

require 'bundler'

Bundler.require(:default)

require 'tilt_hydrometer'

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
