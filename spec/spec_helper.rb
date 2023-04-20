# frozen_string_literal: true

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
  add_filter 'lib/tilt_hydrometer/version.rb'
end

require 'bundler'

Bundler.require(:default)

require 'webmock/rspec'
require 'timecop'
RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
