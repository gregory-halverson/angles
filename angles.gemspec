# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'angles/version'

Gem::Specification.new do |spec|
  spec.name          = "angles"
  spec.version       = Angles::VERSION
  spec.authors       = ["Gregory H. Halverson"]
  spec.email         = ["gregory.halverson@gmail.com"]
  spec.summary       = %q{Angle class}
  spec.description   = %q{Encapsulates angles in Ruby. Easily switch between degrees and radians. Output in human-readable format. Built-in trig functions. Automatically normalize angles.}
  spec.homepage      = "https://github.com/gregory-halverson/angles"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
