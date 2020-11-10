# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name        = 'tilt_hydrometer'
  s.version     = '0.0.0'
  s.date        = '2020-11-10'
  s.summary     = 'Tilt Hydrometer'
  s.description = 'Read Tilt Hydrometer beacons and post to Brewfather'
  s.authors     = ['Steffen Schröder']
  s.email       = 'steffen@schroeder-blog.de'
  s.executables << 'tilt_hydrometer'
  s.files       = ['lib/tilt_hydrometer.rb']
  s.homepage    =
    'https://github.com/ChaosSteffen/tilt_hydrometer'
  s.license     = 'BSD-2-Clause'
  s.add_runtime_dependency 'faraday', '1.1.0'
  s.add_runtime_dependency 'scan_beacon', '0.7.11'
  s.required_ruby_version = '>= 2.5.5'
end
