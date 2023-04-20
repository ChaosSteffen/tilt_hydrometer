# frozen_string_literal: true

require 'bundler'

Bundler.require(:default)

require 'simplecov'
require 'simplecov-json'
SimpleCov.formatters = SimpleCov::Formatter::MultiFormatter.new(
  [
    SimpleCov::Formatter::HTMLFormatter,
    SimpleCov::Formatter::JSONFormatter
  ]
)
SimpleCov.start do
  track_files 'lib/**/*.rb'
end

require 'webmock/rspec'

require 'tilt_hydrometer'

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
