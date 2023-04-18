# frozen_string_literal: true

require_relative 'lib/tilt_hydrometer/version'

Gem::Specification.new do |s|
  s.name        = 'tilt_hydrometer'
  s.version     = TiltHydrometer::VERSION
  s.summary     = 'Tilt Hydrometer'
  s.description = 'Read Tilt Hydrometer beacons and post to Brewfather'
  s.authors     = ['Steffen Schröder']
  s.email       = 'steffen@schroeder-blog.de'
  s.executables << 'tilt_hydrometer'
  s.files       = Dir['lib/**/*.rb']
  s.homepage    =
    'https://github.com/ChaosSteffen/tilt_hydrometer'
  s.license     = 'BSD-2-Clause'
  s.add_runtime_dependency 'bundler'
  s.add_runtime_dependency 'faraday', '2.2.0'
  s.add_runtime_dependency 'mqtt', '0.5.0'
  s.required_ruby_version = Gem::Requirement.new('>= 2.7.8')
end
